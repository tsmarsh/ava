module "mongo_atlas" {
  source        = "../../modules/mongo_atlas"
  aws_region    = var.aws_region
  atlas_public  = var.mongo_atlas_public_key
  atlas_private = var.mongo_atlas_private_key
  atlas_org     = "62d9768e48436157054fae9b"
}

module "fargate" {
  source = "../../modules/fargate"
  aws_region = var.aws_region
  aws_profile = "default"
  fargate_cluster_name = "ava_dev_cluster"
}

module "confluent_kafka" {
  source                     = "../../modules/confluent_kafka"
  confluent_cloud_api_key    = var.confluent_cloud_api_key
  confluent_cloud_api_secret = var.confluent_cloud_api_secret
}
