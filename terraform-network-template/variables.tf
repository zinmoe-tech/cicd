variable "aws_region" {
  description = "AWS region where the network will be created."
  type        = string
}

variable "project_name" {
  description = "Project name used for resource names and tags."
  type        = string
}

variable "environment" {
  description = "Environment name such as dev, stage, or prod."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used for public and private subnets."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets. Must match the number of availability zones."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets. Must match the number of availability zones."
  type        = list(string)
}

variable "allowed_ssh_cidrs" {
  description = "CIDR blocks allowed to SSH to resources using the public security group."
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT gateway resources for private subnet internet egress."
  type        = bool
  default     = true
}

variable "single_nat_gateway" {
  description = "Create one NAT gateway instead of one per public subnet. Cheaper for dev, less resilient for prod."
  type        = bool
  default     = true
}

variable "common_tags" {
  description = "Additional tags applied to every resource."
  type        = map(string)
  default     = {}
}

