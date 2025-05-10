module "vpc" {
  source     = "./modules/vpc"
  vpc_cidr   = var.vpc_cidr
  environment = terraform.workspace
}
