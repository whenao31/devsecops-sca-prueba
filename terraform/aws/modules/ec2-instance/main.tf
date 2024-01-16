resource "aws_instance" "ec2_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [ var.security_group_id ]
  key_name = var.aws_ssh_key_name

  user_data = var.user_data_file_path != "" ? "${file("${var.user_data_file_path}")}" : null

  tags = merge(var.custom_tags, {
    Name = var.instance_name
  })
}