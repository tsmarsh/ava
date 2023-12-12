output "mongodb_connection_string" {
  value = mongodbatlas_cluster.cluster.connection_strings[0].standard
}