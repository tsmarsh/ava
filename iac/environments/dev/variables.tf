variable "mongo_atlas_public_key" {
  description = "Public Key for MongoDB Atlas"
}

variable "mongo_atlas_private_key" {
  description = "Private Key for MongoDB Atlas"
}

variable "aws_region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "confluent_cloud_api_key" {
  default = ""
}
variable "confluent_cloud_api_secret" {
  default = ""
}