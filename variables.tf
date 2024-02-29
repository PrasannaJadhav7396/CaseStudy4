variable "region" {
 type = string
 default = "us-east-1"
 description = "AWS region"
}

variable "environment_id" {
 type = string
 default = "Dev"
 description = "Environment"
}

variable "ami_id" {
 type = string
 default = "ami-0440d3b780d96b29d"
 description = "AWS AMI ID needed for EC2 instances"
}

variable "instance_type" {
 type = string
 default = "t2.micro"
 description = "To enable/create resources"
 description = "AWS instance type for EC2 instances"
}

variable "enabled" {
 type = number
 default = 1
 description = "To enable/create resources"
}

variable "zones" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b",
    "us-east-1c"
  ]
  description = "List of availability zones"
}
 