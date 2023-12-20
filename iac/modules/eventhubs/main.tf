variable "location" {}

variable "resource_group" {}

variable "partition_count" {
  default = 2
}

variable "message_retention" {
  default = 1
}

variable "sku" {
  default = "Basic"
}

variable "capacity" {
  default = 1
}

resource "azurerm_eventhub_namespace" "ava" {
  name                = "ava-eventhub-ns"
  location            = var.location
  resource_group_name = var.resource_group
  sku                 = var.sku
  capacity            = var.capacity
  # Need to figure out how to get kafka enabled
  # kafka_enabled       = true
}

resource "azurerm_eventhub" "ava" {
  name                = "ava-eventhub"
  namespace_name      = azurerm_eventhub_namespace.ava.name
  resource_group_name = var.resource_group
  partition_count     = var.partition_count
  message_retention   = var.message_retention

}

output "connection_string" {
  value = "${azurerm_eventhub_namespace.ava.name}.servicebus.windows.net:9093"
}
