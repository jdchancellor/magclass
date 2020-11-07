output "vpc_id" {
  value = aws_vpc.vpc-non-default.id
}

output "vpc_arn" {
  value = aws_vpc.vpc-non-default.arn
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc-non-default.cidr_block
}

output "vpc_enable_dns_support" {
  value = aws_vpc.vpc-non-default.enable_dns_support
}

output "vpc_igw_id" {
  value = aws_internet_gateway.vpc_igw.id
}
