# Define the VPC
resource "aws_vpc" "vpc_dev" {
  cidr_block = "10.0.0.0/16"
}
 
# Define subnets in different availability zones
resource "aws_subnet" "subnet_a" {
  count             = length(var.zones) 
  vpc_id            = aws_vpc.vpc_dev.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = element(var.zones, count.index)
}
 
resource "aws_subnet" "subnet_b" {
  count             = length(var.zones)
  vpc_id            = aws_vpc.vpc_dev.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = element(var.zones, count.index)
}
 
resource "aws_subnet" "subnet_c" {
  count             = length(var.zones)
  vpc_id            = aws_vpc.vpc_dev.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = element(var.zones, count.index)
}
 
# Create security group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.vpc_dev.id
 
  # Add inbound rule to allow SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
 
# Define EC2 instances in separate availability zones
resource "aws_instance" "ec2_instance_1" {
  count                  	  = var.enabled
  ami                         = var.ami_id 
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_a.id
  security_group_ids          = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
 
  # Install Docker and s3fs on instance
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              systemctl enable docker
              yum install -y amazon-efs-utils
              EOF
}

resource "aws_instance" "ec2_instance_2" {
  count                  	  = var.enabled
  ami                         = var.ami_id 
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_b.id
  security_group_ids          = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
 
  # Install Docker and s3fs on instance
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              systemctl enable docker
              yum install -y amazon-efs-utils
              EOF
}

resource "aws_instance" "ec2_instance_3" {
  count                  	  = var.enabled
  ami                         = var.ami_id 
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_c.id
  security_group_ids          = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
 
  # Install Docker and s3fs on instance
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y docker
              service docker start
              systemctl enable docker
              yum install -y amazon-efs-utils
              EOF
}
 
 
# Create S3 bucket
resource "aws_s3_bucket" "shared_bucket" {
  count  = var.enabled
  bucket = "shared-bucket"
 
  lifecycle {
    prevent_destroy = true
  }
  
  versioning {
    enabled = true
  }
  
  tags = {
    Name = "Shared Bucket"
  }
}
 
# S3 Bucket ACL 
resource "aws_s3_bucket_acl" "source_bucket" {
  count  = var.enabled
  bucket = aws_s3_bucket.shared_bucket[count.index].id
  acl    = "private"
}
