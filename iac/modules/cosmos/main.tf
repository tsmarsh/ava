variable "location" {}

variable "resource_group" {}

variable "sku" {
  default = "Standard"
}

variable "failover_priority" {
  default = 0
}

resource "azurerm_cosmosdb_account" "ava" {
  name                = "ava-cosmosdb-account"
  location            = var.location
  resource_group_name = var.resource_group
  offer_type          = "Standard"
  kind                = "MongoDB"

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = var.failover_priority
  }
}

output "connection_string" {
  value = azurerm_cosmosdb_account.ava.connection_strings[0]
}