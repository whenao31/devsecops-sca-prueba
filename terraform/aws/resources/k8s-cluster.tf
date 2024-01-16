# module "app_cluster" {
#   source = "../modules/eks-cluster"

#   public_subnets_ids  = module.network_vpc.public_subnets_id_list
#   private_subnets_ids = module.network_vpc.private_subnets_id_list
# }