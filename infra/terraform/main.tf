module "vpc" {
  source       = "./vpc"
  project_name = var.project_name
}

module "security" {
  source = "./security"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source          = "./alb"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  alb_sg          = module.security.alb_sg
}

module "ec2" {
  source          = "./ec2"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets

  sg_nginx   = module.security.nginx_sg
  sg_app     = module.security.app_sg
  sg_db      = module.security.db_sg
  sg_bastion = module.security.bastion_sg
}

module "asg" {
  source          = "./asg"
  private_subnets = module.vpc.private_subnets
  target_group    = module.alb.target_group_arn
  sg_app          = module.security.app_sg
}
