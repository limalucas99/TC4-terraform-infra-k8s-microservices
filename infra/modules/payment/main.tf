resource "mongodbatlas_project" "tc4_fiap" {
  name   = "tc4-fiap"
  org_id = var.organization_id
}

resource "mongodbatlas_advanced_cluster" "tc4_mongodb_cluster" {
  project_id     = mongodbatlas_project.tc4_fiap.id
  name           = "tc4-cluster"
  cluster_type   = "REPLICASET"

  replication_specs {
    region_configs {
      electable_specs {
        instance_size = "M0"
      }
      provider_name         = "TENANT"
      backing_provider_name = "AWS"
      region_name           = "US_EAST_1"
      priority              = 7
    }
  }
}

resource "mongodbatlas_database_user" "db_user" {
  username           = var.payment_db_username
  password           = var.payment_db_password
  project_id         = mongodbatlas_project.tc4_fiap.id
  auth_database_name = "admin"

  roles {
    role_name     = "readAnyDatabase"
    database_name = "admin"
  }
}