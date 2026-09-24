output "vpc_id" {
  description = "Created VPC ID."
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "Created VPC CIDR block."
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "Internet gateway ID."
  value       = aws_internet_gateway.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "public_security_group_id" {
  description = "Public security group ID."
  value       = aws_security_group.public.id
}

output "private_security_group_id" {
  description = "Private security group ID."
  value       = aws_security_group.private.id
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs. Empty when NAT is disabled."
  value       = aws_nat_gateway.main[*].id
}

