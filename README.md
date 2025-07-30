# ☁️ Infraestrutura – Terraform + Kubernetes (TC4)

Este repositório representa a **infraestrutura como código** para o sistema de autoatendimento de uma lanchonete em expansão, desenvolvido como parte da **Fase 4 do Tech Challenge** do curso de pós-graduação em Software Architecture da FIAP.

Ele é responsável por provisionar toda a infraestrutura necessária para hospedar os microsserviços do sistema utilizando **Terraform**, **Kubernetes (EKS)**, **Helm**, **AWS RDS**, entre outras ferramentas modernas de DevOps.

## 📦 Visão Geral do Projeto

A infraestrutura foi construída com foco em **orquestração de microsserviços**, garantindo **escalabilidade**, **isolamento**, **observabilidade** e **resiliência**. 

Os seguintes microsserviços são implantados nesta infraestrutura:

- [Martiello.MS.Customer](https://github.com/feligra/Martiello.MS.Customer)
- [Martiello.MS.Kitchen](https://github.com/feligra/Martiello.MS.Kitchen)
- [Martiello.MS.Payment](https://github.com/feligra/Martiello.MS.Payment)

---

## 🛠️ Tecnologias Utilizadas

- **Terraform** – Provisionamento da infraestrutura
- **Kubernetes (EKS/AWS)** – Orquestração dos microsserviços
- **Helm** – Gerenciador de pacotes Kubernetes
- **AWS RDS (PostgreSQL)** – Banco de dados relacional
- **AWS S3** – Armazenamento de estado remoto e artefatos
- **GitHub Actions** – CI/CD dos serviços e infraestrutura
- **kubectl + AWS CLI** – Gerenciamento do cluster
- **Ingress NGINX** – Roteamento de tráfego externo

---

## 🧩 Pré-requisitos

- Conta AWS com permissões adequadas (EKS, RDS, IAM, S3, etc.)
- [Terraform](https://developer.hashicorp.com/terraform/downloads) instalado
- [kubectl](https://kubernetes.io/docs/tasks/tools/) instalado
- [Helm](https://helm.sh/docs/intro/install/) instalado
- AWS CLI configurado com `aws configure`

---

## 🚀 Como Executar

### 1. Clonar o repositório

```bash
git clone https://github.com/limalucas99/TC4-terraform-infra-k8s-microservices.git
cd TC4-terraform-infra-k8s-microservices
```

### 2. Inicializar Terraform

```bash
terraform init
```

### 3. Visualizar mudanças

```bash
terraform plan
```

### 4. Aplicar infraestrutura

```bash
terraform apply
```

> **Obs:** Pode demorar alguns minutos até que os recursos na AWS estejam prontos.

---

## ☸️ Deploy dos Microsserviços via Helm

Após o provisionamento da infraestrutura com sucesso, aplique os charts Helm localizados na pasta `/charts` (ou nos repositórios específicos dos serviços):

```bash
helm upgrade --install customer ./charts/customer
helm upgrade --install kitchen ./charts/kitchen
helm upgrade --install payment ./charts/payment
```

---

## 📁 Estrutura de Pastas

```
.
├── main.tf               # Configurações principais do Terraform
├── variables.tf          # Variáveis customizáveis da infraestrutura
├── outputs.tf            # Saídas relevantes (ex: endpoint EKS, DNS)
├── modules/              # Módulos reutilizáveis (eks, rds, vpc, etc.)
├── charts/               # Helm charts dos microsserviços
└── environments/
    ├── dev/              # Configuração para ambiente de desenvolvimento
    └── prod/             # Configuração para ambiente de produção
```

---

## 📊 Observabilidade

Para métricas e logs, recomenda-se a integração com:

- **AWS CloudWatch** (logs, métricas de serviços e containers)
- **Prometheus + Grafana** (caso deseje observabilidade in-cluster)

---

## 🧪 Testes & CI/CD

- As pipelines de CI/CD estão definidas nos próprios repositórios dos microsserviços.
- Este repositório pode ser estendido com GitHub Actions para validar `terraform plan` e `terraform apply` em ambientes de staging.

---

## 📄 Licença

Projeto acadêmico para fins educacionais na pós-graduação em Software Architecture da FIAP.
