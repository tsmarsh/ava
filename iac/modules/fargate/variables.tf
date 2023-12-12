variable "fargate_cluster_name" {
  description = "What to call the cluster in fargate"
}

variable "fargate_cpu" {
  default = "256"
}

variable "fargate_memory" {
  default = "512"
}

variable "fargate_service_name" {
  default = ""
}

variable "subnet_ids" {
  default = ""
}

variable "sg_id" {
  default = ""
}

variable "vpc_id" {
  default = ""
}

variable "lb_arn" {}

variable "docker_name" {
  default = ""
}
variable "docker_image" {
  default = ""
}

variable "docker_port" {
  default = 3000
}

variable "telegram_port" {
  default = 3000
}

variable "mongo_uri" {
  default = "mongodb://localhost:27017"
}