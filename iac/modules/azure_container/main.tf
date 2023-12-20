variable "location" {}

variable "resource_group" {}

variable "connection_string" {}

variable "security_group" {}

variable "image" {}

variable "cpu" {
  default = "0.5"
}

variable "memory" {
  default = "1.5"
}

resource "azurerm_container_group" "ava" {
  name                = "ava-containergroup"
  location            = var.location
  resource_group_name = var.resource_group
  os_type             = "Linux"

  container {
    name   = "telegram"
    image  = "tsmarsh/ava-telegram:0.0.2"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 3000
      protocol = "TCP"
    }

    environment_variables = {
      "MONGO_URI" = var.connection_string
    }
  }

  ip_address_type = "Public"
  dns_name_label  = "ava-telegram"
}

resource "azurerm_network_security_rule" "ava" {
  name                        = "HTTP"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3000"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group
  network_security_group_name = var.security_group
}
