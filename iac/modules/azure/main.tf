resource "azurerm_resource_group" "ava" {
  name     = "ava-resources"
  location = "East US"
}

resource "azurerm_network_security_group" "ava" {
  name                = "ava-nsg"
  location            = azurerm_resource_group.ava.location
  resource_group_name = azurerm_resource_group.ava.name
}

resource "azurerm_network_security_rule" "ava" {
  name                        = "HTTPS"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.ava.name
  network_security_group_name = azurerm_network_security_group.ava.name
}

resource "azurerm_cosmosdb_account" "ava" {
  name                = "ava-cosmosdb-account"
  location            = azurerm_resource_group.ava.location
  resource_group_name = azurerm_resource_group.ava.name
  offer_type          = "Standard"
  kind                = "MongoDB"

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.ava.location
    failover_priority = 0
  }
}

resource "azurerm_eventhub_namespace" "ava" {
  name                = "ava-eventhub-ns"
  location            = azurerm_resource_group.ava.location
  resource_group_name = azurerm_resource_group.ava.name
  sku                 = "Basic"
  capacity            = 1
}

resource "azurerm_eventhub" "ava" {
  name                = "ava-eventhub"
  namespace_name      = azurerm_eventhub_namespace.ava.name
  resource_group_name = azurerm_resource_group.ava.name
  partition_count     = 2
  message_retention   = 1
}


resource "azurerm_container_group" "ava" {
  name                = "ava-containergroup"
  location            = azurerm_resource_group.ava.location
  resource_group_name = azurerm_resource_group.ava.name
  os_type             = "Linux"

  container {
    name   = "telegram"
    image  = "tsmarsh/ava-telegram:0.0.1"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    environment_variables = {
      "MONGO_URI" = azurerm_cosmosdb_account.ava.connection_strings[0]
    }
  }

  ip_address_type = "Public"
  dns_name_label  = "ava-app"
}

output "container_group_ip_address" {
  value = azurerm_container_group.ava.ip_address
}

output "cosmosdb_mongo_connection_string" {
  value = azurerm_cosmosdb_account.ava.connection_strings[0]
}
