variable "organization_id" {
  description = "MongoDB Atlas organization ID"
  type        = string
}

variable "public_key" {
  description = "Public key for MongoDB Atlas"
  type        = string
}

variable "private_key" {
  description = "Private key for MongoDB Atlas"
  type        = string
}

variable "payment_db_username" {
  description = "Username for the payment database"
  type        = string
}

variable "payment_db_password" {
  description = "Password for the payment database"
  type        = string
}

variable "kitchen_db_username" {
  description = "Username for the kitchen database"
  type        = string
}

variable "kitchen_db_password" {
  description = "Password for the kitchen database"
  type        = string
}

variable "customer_db_username" {
  description = "Username for the customer database"
  type        = string
}

variable "customer_db_password" {
  description = "Password for the customer database"
  type        = string
}