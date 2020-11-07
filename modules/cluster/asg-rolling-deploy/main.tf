terraform {
  required_version = ">= 0.13, <0.14"
}


locals {
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}


resource "aws_launch_configuration" "web_instance" {
  image_id        = var.ami
  instance_type   = var.instance_type
  security_groups = [aws_security_group.instance.id]
  user_data       = var.user_data

  # Required when using a launch configuration with an auto-scaling group 
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "web_cluster" {
  # Explicitly depend on the launch configuration's name
  # so each time it is replaced/updated, this ASG is also replaced/updated
  name = "${var.cluster_name}-${aws_launch_configuration.web_instance.name}"

  launch_configuration = aws_launch_configuration.web_instance.name
  vpc_zone_identifier  = var.subnet_ids

  # Configure the load balancer integration
  target_group_arns = var.target_group_arns
  health_check_type = var.health_check_type

  min_size = var.min_size
  max_size = var.max_size

  # Wait for at least this many instances to pass the health check
  # before considering the ASG deployment complete
  min_elb_capacity = var.min_size

  # When replacing this ASG, create the replacement first
  # and only delete the original after
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propogate_at_launch = true
  }

  # Create a dynamic set of tags using the map in var.custom_tags
  dynamic "tag" {
    for_each = {
      for key, value in var.custom_tags :
      key => upper(value)
      if key != "Name"
    }

    content {
      key                 = tag.key
      value               = tag.value
      propogate_at_launch = true
    }
  }

}


resource "aws_autoscaling_schedule" "business_hours_scale_out" {
  # A conditional is used to manage autoscaling schedules for environments that require them
  # by setting the count to 0 when enable_autoscaling is false, this rule is not created
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name      = "${var.cluster_name}-business-hours-scale-out"
  min_size                   = 2
  max_size                   = 10
  desired_capacity           = 10
  recurrence                 = "0 9 * * *"
  aws_autoscaling_group_name = aws_autoscaling_group.web_cluster.name
}


resource "aws_autoscaling_schedule" "business_hours_scale_out" {
  # A conditional is used to manage autoscaling schedules for environments that require them
  # by setting the count to 0 when enable_autoscaling is false, this rule is not createdg
  count = var.enable_autoscaling ? 1 : 0

  scheduled_action_name      = "${var.cluster_name}-after-hours-scale-in"
  min_size                   = 2
  max_size                   = 10
  desired_capacity           = 2
  recurrence                 = "0 17 * * *"
  aws_autoscaling_group_name = aws_autoscaling_group.web_cluster.name
}


resource "aws_security_group" "web_instances" {
  name = "${var.cluster_name}-instance-secgroup"
}


resource "aws_security_group_rule" "allow_server_http_inbound" {
  type              = "ingress"
  security_group_id = aws_security_group.web_instance.image_id

  from_port   = var.server_port
  to_port     = var.server_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}


resource "aws_cloudwatch_metric_alarm" "high_cpu_utilization" {
  alarm_name  = "${var.cluster_name}-high-cpu-utilization"
  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_cluster.name
  }

  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Average"
  threshold           = 90
  unit                = "Percent"
}


resource "aws_cloudwatch_metric_alarm" "low_cpu_credit_balance" {
  # If instances is of type tXXXX then create a low cpu credit balance alarm
  count = format("%.1s", var.instance_type) == "t" ? 1 : 0

  alarm_name  = "${var.cluster_name}-low-cpu-credit-balance"
  namespace   = "AWS/EC2"
  metric_name = "CPUCreditBalance"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.web_cluster.name
  }

  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  period              = 300
  statistic           = "Minimum"
  threshold           = 10
  unit                = "Count"
}


