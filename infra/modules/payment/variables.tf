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