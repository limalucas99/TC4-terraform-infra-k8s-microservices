terraform {
  backend "s3" {
    bucket       = "tc4-microservices-k8s-bucket"
    key          = "microservices-k8s/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}