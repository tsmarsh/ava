module "mongo_atlas" {
  source        = "../../modules/mongo_atlas"
  region    = var.aws_region
  atlas_public  = var.mongo_atlas_public_key
  atlas_private = var.mongo_atlas_private_key
  atlas_org     = "62d9768e48436157054fae9b"
  atlas_project_name = "ava_dev"
}

module "network" {
  source = "../../modules/aws_network"
  aws_region = var.aws_region
}

module "fargate" {
  source = "../../modules/fargate"
  depends_on = [module.network, module.mongo_atlas]
  fargate_cluster_name = "ava_dev_cluster"
  mongo_uri = module.mongo_atlas.mongodb_connection_string
  sg_id = module.network.sg_id
  subnet_ids = module.network.subnet_ids
  vpc_id = module.network.vpc_id
  docker_name = "telegram"
  docker_image = "tsmarsh/gridql:0.1.0"
  fargate_service_name = "ava_dev_service"
  lb_arn = module.network.lb_arn
}

