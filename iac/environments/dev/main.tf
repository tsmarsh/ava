module "infra" {
  source = "../../modules/azure_infra"
}

module "database" {
  source = "../../modules/cosmos"
  depends_on = [module.infra]
  resource_group = module.infra.resource_group
  location = module.infra.location
}

module "queue" {
  source = "../../modules/eventhubs"
  depends_on = [module.infra]
  resource_group = module.infra.resource_group
  location = module.infra.location
}

module "containers" {
  depends_on = [module.infra, module.database]
  source = "../../modules/azure_container"
  connection_string = module.database.connection_string
  image = "tsmarsh/ava-telegram:0.0.2"
  resource_group = module.infra.resource_group
  security_group = module.infra.security_group
  location = module.infra.location
}