terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region      = var.aws_region
  access_key  = var.aws_access_key
  secret_key  = var.aws_secret_key
}

module "network" {
  source        = "./network"
  deploy_name   = var.deploy_name
}

module "compute" {
  source        = "./compute"
  deploy_name   = var.deploy_name
  public_subnet_id_a = module.network.public_subnet_id_a
  public_subnet_id_b = module.network.public_subnet_id_b
  public_sg_id = module.network.public_sg_id
  public_lb_tg_id = module.network.public_lb_tg_id
  private_lb_dns = module.network.private_lb_dns
  private_subnet_id_a = module.network.private_subnet_id_a
  private_subnet_id_b = module.network.private_subnet_id_b
  private_sg_id = module.network.private_sg_id
  private_lb_tg_id = module.network.private_lb_tg_id
  db_username = var.db_username
  db_password = var.db_password
  db_endpoint = module.rds.mysql_endpoint
}

module "rds" {
  source        = "./rds"
  deploy_name   = var.deploy_name
  db_subnet_id_a = module.network.db_subnet_a
  db_subnet_id_b = module.network.db_subnet_b
  db_securitygroup_id = module.network.db_sg_id
  db_username = var.db_username
  db_password = var.db_password
}

