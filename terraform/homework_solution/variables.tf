variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_region" {
  type        = string
  description = "Region for AWS Resources"
  default     = "eu-west-1"
}

variable "vpc_name" {
  type = string
  description = "VPC Name"
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR block"
}

variable "vpc_azs" {
  type = list(string)
  description = "VPC Availability zones"
}

variable "private_subnets_cidr" {
  type = list(string)
  description = "Private subnets CIDR"
}

variable "public_subnets_cidr" {
  type = list(string)
  description = "Public subnets CIDR"
}

variable "public_key" {
  type = string
  description = "Your SSH public key"
}
