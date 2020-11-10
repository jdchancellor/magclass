terraform {
  required_version = ">=0.13, <0.14"
}

locals {
  tcp_protocol  = "tcp"
  all_ips       = ["0.0.0.0/0"]
  http_protocol = "HTTP"
}

data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    server_port = var.server_port
    db_address  = data.terraform_remote_state.db.outputs.address
    db_port     = data.terraform_remote_state.db.outputs.port
    server_text = var.server_text
  }
}

data "terraform_remote_state" "db" {
  backend = "s3"

  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = var.db_remote_state_bucket_region
  }
}

data "aws_subnet_ids" "alb" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Type = "loadbalancers"
  }
}

data "aws_subnet_ids" "asg" {
  vpc_id = data.aws_vpc.vpc.id

  tags = {
    Type = "instances"
  }
}

data "aws_vpc" "vpc" {
  tags = {
    Type        = "webapp-vpc"
    environment = var.environment
  }
}

#get the latest AMI version for aws-linux
data "aws_ami" "aws-linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-hvm*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



module "asg" {
  source = "../../cluster/asg-rolling-deploy"

  cluster_name  = "hello-world-${var.environment}-asg"
  ami           = data.aws_ami.ubuntu.id
  user_data     = data.template_file.user_data.rendered
  instance_type = var.instance_type
  vpc_id        = data.aws_vpc.vpc.id

  min_size              = var.min_size
  max_size              = var.max_size
  enable_autoscaling    = var.enable_autoscaling
  rds_security_group_id = var.rds_security_group_id

  subnet_ids        = data.aws_subnet_ids.asg.ids
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  custom_tags = var.custom_tags
}

module "alb" {
  source = "../../networking/alb-web-cluster"

  alb_name   = "hello-world-${var.environment}-alb"
  subnet_ids = data.aws_subnet_ids.alb.ids
  vpc_id     = data.aws_vpc.vpc.id
}

resource "aws_lb_target_group" "asg" {
  name     = "hello-world-${var.environment}"
  port     = var.server_port
  protocol = local.http_protocol
  vpc_id   = data.aws_vpc.vpc.id

  health_check {
    path                = "/"
    protocol            = local.http_protocol
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener_rule" "asg" {
  listener_arn = module.alb.alb_http_listener_arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}


