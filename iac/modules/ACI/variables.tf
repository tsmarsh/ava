variable "docker_name" {
  default = ""
}
variable "docker_image" {
  default = ""
}

variable "docker_port" {
  default = 3000
}

variable "host_port" {
  default = 3000
}

variable "mongo_url" {
  default = "mongodb://localhost:27017"
}

variable "aci_cpu" {
  default = "0.5"
}

variable "aci_memory" {
  default = "1.5"
}

variable "aci_region" {
  default = "West US"
}