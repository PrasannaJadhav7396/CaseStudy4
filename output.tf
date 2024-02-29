 # Output EC2 instance IPs
output "ec2_instance_ips" {
  value = [
    aws_instance.ec2_instance_1[0].public_ip,
    aws_instance.ec2_instance_2[0].public_ip,
	aws_instance.ec2_instance_3[0].public_ip
  ]
}
