variable "vpc_name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
  default = "10.128.0.0/16"
}

variable "subnet_name" {
  type = string
  default = "main-subnet"
}

variable "enable_nat" {
  type = bool
  default = false
}