data "aws_vpc" "default" { default = true }

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "customer-db-subnet-group"
  subnet_ids = data.aws_subnets.subnets.ids
}

resource "aws_security_group" "customer-db-sg" {
  name   = "customer-db-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description      = "Customer DB Remote Access"
    from_port        = 5432
    to_port          = 5432
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]   
    ipv6_cidr_blocks = ["::/0"]       
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_db_instance" "customer_service_db" {
  identifier              = "customer-service-db"
  db_name                 = "customer_service_db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10
  username                = var.customer_db_username
  password                = var.customer_db_password
  publicly_accessible     = true

  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.customer-db-sg.id]

  skip_final_snapshot     = true
  storage_encrypted       = true
}

resource "aws_secretsmanager_secret" "customer_db_secret" {
  name        = "customer-db-secret"
  description = "Credenciais e endpoint do banco de dados Customer Service"
}

resource "aws_secretsmanager_secret_version" "customer_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.customer_db_secret.id
  secret_string = jsonencode({
    username = var.customer_db_username,
    password = var.customer_db_password,
    db_host = aws_db_instance.customer_service_db.address,
    db_name  = aws_db_instance.customer_service_db.db_name
  })
}

