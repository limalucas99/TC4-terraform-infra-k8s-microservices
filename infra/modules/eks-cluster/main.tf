data "aws_iam_role" "lab_role" {
  name = "LabRole"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

locals {
  subnets = [
    { cidr = "10.0.1.0/24", az = "us-east-1a" },
    { cidr = "10.0.2.0/24", az = "us-east-1b" }
  ]
}

resource "aws_subnet" "public" {
  for_each                = { for s in local.subnets : s.az => s }
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "eks_cluster_sg" {
  name        = "tc4-k8s-cluster-cluster-sg"
  description = "tc4 cluster SG"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eks_cluster" "k8s_cluster" {
  name     = "tc4-k8s-cluster"
  role_arn = data.aws_iam_role.lab_role.arn

  vpc_config {
    subnet_ids         = values(aws_subnet.public)[*].id
    security_group_ids = [aws_security_group.eks_cluster_sg.id]
  }

}

resource "aws_eks_node_group" "k8s_node_group" {
  cluster_name    = aws_eks_cluster.k8s_cluster.name
  node_group_name = "tc4-k8s-node-group"
  node_role_arn   = data.aws_iam_role.lab_role.arn
  subnet_ids      = values(aws_subnet.public)[*].id

  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  timeouts { create = "30m" }
}

resource "aws_secretsmanager_secret" "k8s_secret" {
  name        = "k8s-db-secret"
  description = "Credenciais do Cluster EKS para k8s"
}

resource "aws_secretsmanager_secret_version" "k8s_secret_version" {
  secret_id     = aws_secretsmanager_secret.k8s_secret.id
  secret_string = jsonencode({
    endpoint = aws_eks_cluster.k8s_cluster.endpoint,
    id = aws_eks_cluster.k8s_cluster.id,
  })
}