# region 
variable "region_aws" {
default = "eu-west-2"
}

# vpc cidr block
variable "Prod-rock-VPC-cidr_block" {
    default = "10.0.0.0/16"
    description = "Prod-rock-VPC"
}

# creating 2 public Test subnets
variable "aws_subnet-Test-public-sub1-cidr_block" {
  default = "10.0.1.0/24"
  description = "Test-public-sub1-cidr_block"
}

variable "Test-public-sub2-cidr_block" {
  default = "10.0.2.0/24"
  description = "Test-public-sub2-cidr_block"
}

# creating 2 private Test subnets
variable "Test-priv-sub1-cidr_block" {
  default = "10.0.3.0/24"
  description = "Test-priv-sub1-cidr_block"
}

variable "Test-priv-sub2-cidr_block" {
  default = "10.0.4.0/24"
  description = "Test-priv-sub2-cidr_block"
}

# Internet gateway attachment (route)
variable "Test-igw-association-aws_route" {
  default = "0.0.0.0/0"
  description = "Test-igw-association-aws_route"
}

# create Security group for the ec2 instance
variable "ec2_security_group-aws_security_group" {
  default = "allow acess on port 80 and 22"
  description = "ec2_security_group-aws_security_group"
}

#creating ec2 instances in both private and public subnets
variable "aws_instance-Test-server-1" {
default = "ami-0f540e9f488cfa27d"
description = "Test-server-1"
}

variable "aws_instance-Test-server-2" {
default = "ami-0f540e9f488cfa27d"
description = "Test-server-2"
}