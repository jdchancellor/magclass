output "asg_name" {
  value       = aws_autoscaling_group.web_cluster.name
  description = "The name of the auto-scaling-group"
}

output "instance_security_group_id" {
  value       = aws_security_group.web_instance.instance_security_group_id
  description = "The ID of the security group for the EC2 instances"
}
