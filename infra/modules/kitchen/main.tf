data "aws_vpc" "default" { default = true }

data "aws_subnets" "subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "kitchen-db-subnet-group"
  subnet_ids = data.aws_subnets.subnets.ids
}

resource "aws_security_group" "kitchen-db-sg" {
  name   = "kitchen-db-sg"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description      = "Kitchen DB Remote Access"
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

resource "aws_db_instance" "kitchen_service_db" {
  identifier              = "kitchen-service-db"
  db_name                 = "kitchen_service_db"
  engine                  = "postgres"
  instance_class          = "db.t3.micro"
  allocated_storage       = 10
  username                = var.kitchen_db_username
  password                = var.kitchen_db_password
  publicly_accessible     = true

  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.kitchen-db-sg.id]

  skip_final_snapshot     = true
  storage_encrypted       = true
}

resource "aws_secretsmanager_secret" "kitchen_db_secret" {
  name        = "kitchen-db-secret"
  description = "Credenciais e endpoint do banco de dados Kitchen Service"
}

resource "aws_secretsmanager_secret_version" "kitchen_db_secret_version" {
  secret_id     = aws_secretsmanager_secret.kitchen_db_secret.id
  secret_string = jsonencode({
    username = var.kitchen_db_username,
    password = var.kitchen_db_password,
    db_host = aws_db_instance.kitchen_service_db.address,
    db_name  = aws_db_instance.kitchen_service_db.db_name
  })
}


