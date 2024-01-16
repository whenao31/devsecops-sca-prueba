module "network_vpc" {
  source      = "../modules/network"
  vpc_name    = "sca-devsecops-vpc"
  subnet_name = "sca-devsecops-subnet"
  # enable_nat  = true
}

output "eks_nodes_subnet_ids" {
  value = module.network_vpc.private_subnets_id_list
}