module "network" {
  source = "../../modules/network"

  project_name       = var.project_name
  environment        = var.environment
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone

  tags = local.common_tags
}

module "iam" {
  source = "../../modules/iam"

  project_name = var.project_name
  environment  = var.environment

  tags = local.common_tags
}

module "compute" {
  source = "../../modules/compute"

  aws_region                = var.aws_region
  project_name              = var.project_name
  environment               = var.environment
  vpc_id                    = module.network.vpc_id
  public_subnet_id          = module.network.public_subnet_id
  iam_instance_profile_name = module.iam.instance_profile_name
  instance_type             = var.instance_type
  key_name                  = var.key_name
  enable_ssh                = var.enable_ssh
  admin_access_cidr         = var.admin_access_cidr
  root_volume_size          = var.root_volume_size

  tags = local.common_tags
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"

  project_name       = var.project_name
  environment        = var.environment
  ec2_instance_id    = module.compute.instance_id
  log_retention_days = var.log_retention_days
  alert_email        = var.alert_email

  tags = local.common_tags
}
