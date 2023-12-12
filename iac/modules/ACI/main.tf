provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "ava_rg" {
  name     = "aciResourceGroup"
  location = var.aci_region
}

resource "azurerm_container_group" "ava_cg" {
  name                = "avaContainerGroup"
  location            = azurerm_resource_group.ava_rg.location
  resource_group_name = azurerm_resource_group.ava_rg.name
  os_type             = "Linux"

  container {
    name   = var.docker_name
    image  = var.docker_image
    cpu    = var.aci_cpu
    memory = var.aci_memory

    ports {

      port     = var.docker_port
      protocol = "TCP"
    }

    environment_variables = {
      MONGO_URI = var.mongo_url
    }
  }

  ip_address {
    type = "Public"
    ports {
      port     = var.host_port
      protocol = "TCP"
    }
  }

  tags = {
    environment = "testing"
  }
}

# Add any additional configurations as needed
