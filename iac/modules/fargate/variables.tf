variable "aws_profile" {
  default = "default"
}

variable "aws_region" {
  default = "us-east-2"
}

variable "fargate_cluster_name" {
  description = "What to call the cluster in fargate"
}

variable "fargate_cpu" {
  default = "256"
}

variable "fargate_memory" {
  default = "512"
}

variable "docker_name" {
  default = ""
}
variable "docker_image" {
  default = ""
}

variable "fargate_service_name" {
  default = ""
}

variable "docker_port" {
  default = 3000
}

variable "host_port" {
  default = 3000
}