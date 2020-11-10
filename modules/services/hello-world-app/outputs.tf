output "alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "the domain name of the load balancer"
}

output "asg_name" {
  value       = module.asg.asg_name
  description = "The name of the autoscaling group"
}

output "instance_security_group_id" {
  value       = module.asg.instance_security_group_id
  description = "The ID of the EC2 instance security group"
}
