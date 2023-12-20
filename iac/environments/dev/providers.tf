terraform {
  cloud {
    organization = "BlackShapes"

    workspaces {
      name = "ava-dev"
    }
  }
}

provider "azurerm" {
  features {}
}
