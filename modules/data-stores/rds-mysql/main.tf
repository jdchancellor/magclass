terraform {
  required_version = ">=0.13, >0.14"
}

resource "aws_db_instance" "webapp-rds" {
  identifier-prefix   = "webapp"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}

resource "aws_security_group" "rds" {
  name        = "rds"
  description = "rds_security_group"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "rds_security_group"
    environment = var.environment
    Createdby   = "terraform"
  }
}

resource "aws_security_group_rule" "mysql_inbound" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = var.server_security_group_id
  security_group_id        = aws_security_group.rds.id
}

resource "aws_security_group_rule" "rds_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.rds.id
}
