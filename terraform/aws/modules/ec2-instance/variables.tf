variable "instance_name" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t3a.micro"
}

variable "ami_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "aws_ssh_key_name" {
  type = string
}

variable "security_group_id" {
  type = string
}

variable "user_data_file_path" {
  type = string
  default = ""
}

variable "custom_tags" {
  type = map(string)
}