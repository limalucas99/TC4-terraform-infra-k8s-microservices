output "db_endpoint" {
  value = mongodbatlas_advanced_cluster.tc4_mongodb_cluster.connection_strings[0].standard_srv
}