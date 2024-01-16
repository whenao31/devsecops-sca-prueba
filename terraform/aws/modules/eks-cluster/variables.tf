variable "prefix" {
  default = "coco-lab"
}

variable "public_subnets_ids" {
  type = list(string)
}

variable "private_subnets_ids" {
  type = list(string)
}

variable "instance_types" {
  type = list(string)
  default = [ "t2.micro" ]
}

variable "disk_size" {
  default = 10
}

variable "nodes_amount" {
  default = 1
}