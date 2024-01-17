output "aws_ssh_key_name" {
  value = aws_key_pair.ec2-instance-key.key_name
}

output "ssh_key_private_pem" {
  value = tls_private_key.ssh_key.private_key_pem
}

output "ssh_key_private_openssh" {
  value = tls_private_key.ssh_key.private_key_openssh
}