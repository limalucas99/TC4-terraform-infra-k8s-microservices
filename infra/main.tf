module "eks_cluster" {
  source = "./modules/eks-cluster"
}

module "customer" {
  source               = "./modules/customer"
  customer_db_username = var.customer_db_username
  customer_db_password = var.customer_db_password
}

module "kitchen" {
  source              = "./modules/kitchen"
  kitchen_db_username = var.kitchen_db_username
  kitchen_db_password = var.kitchen_db_password
}

module "payment" {
  source              = "./modules/payment"
  organization_id     = var.organization_id
  public_key          = var.public_key
  private_key         = var.private_key
  payment_db_username = var.payment_db_username
  payment_db_password = var.payment_db_password
}