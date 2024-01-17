data "aws_ami" "ubuntu_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20230719"]
    # values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20230502"]
  }
}

module "instance_key_pair" {
  source = "../modules/aws-key-pair"
}

module "sca_service_instance" {
  source        = "../modules/ec2-instance"
  instance_name = "sca-service"
  # ami_id              = data.aws_ami.ubuntu_ami.id #ami-053b0d53c279acc90
  ami_id              = "ami-053b0d53c279acc90"
  instance_type       = "t3a.micro"
  subnet_id           = module.network_vpc.public_subnets_id_list[1]
  aws_ssh_key_name    = module.instance_key_pair.aws_ssh_key_name
  security_group_id   = module.network_vpc.security_group_id
  user_data_file_path = "./sca_service_startup.txt"

  custom_tags = {
    env = "dev"
  }
}

output "sca_service_ssh_pem" {
  value     = module.instance_key_pair.ssh_key_private_pem
  sensitive = true
}