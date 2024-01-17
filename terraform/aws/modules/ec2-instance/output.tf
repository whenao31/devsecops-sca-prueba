output "ec2_instance_public_dns" {
  value = aws_instance.ec2_instance.public_dns
}

output "ec2_instance_public_ip" {
  value = aws_instance.ec2_instance.public_ip
}