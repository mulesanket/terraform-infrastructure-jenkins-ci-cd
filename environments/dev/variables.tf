
variable "key_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "role_arn" {
  type = string
}

# VPC module variables
variable "name_prefix" {
  description = "Name prefix for tagging and resource naming"
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of private subnet CIDRs"
  type        = list(string)
}

variable "azs" {
  description = "List of availability zones to spread resources across"
  type        = list(string)
}

