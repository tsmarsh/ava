terraform {
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.12.3"
    }
  }
}

provider "mongodbatlas" {
  private_key = var.atlas_private
  public_key = var.atlas_public
}

resource "mongodbatlas_project" "ava_project" {
  name   = "ava"
  org_id = var.atlas_org
}

resource "mongodbatlas_cluster" "cluster" {
  project_id   = mongodbatlas_project.ava_project.id
  name         = var.atlas_cluster_name
  disk_size_gb = 10

  provider_name               = "AWS"
  provider_region_name        = var.aws_region
  provider_instance_size_name = "M0"
  backup_enabled              = false
}

resource "mongodbatlas_database_user" "db_user" {
  username      = var.mongo_username
  password      = var.mongo_password
  project_id    = mongodbatlas_project.ava_project.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWriteAnyDatabase"
    database_name = "admin"
  }
}
