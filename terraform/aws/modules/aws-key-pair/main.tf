resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "ec2-instance-key" {
  key_name   = "${var.key-prefix}-ssh-key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}