# 🚀 Projeto Terraform + Docker + Nginx Proxy Reverso

Este projeto cria automaticamente um ambiente Docker com **3 aplicações Nginx** e um **proxy reverso** configurado via Terraform.

## 📁 Estrutura
- `main.tf` → código principal do Terraform  
- `variables.tf` → variáveis reutilizáveis  
- `nginx.conf` → configuração do proxy reverso  
- `terraform.tfstate` → gerado automaticamente  

## 🧰 Pré-requisitos
- Docker instalado e em execução  
- Terraform instalado  

## ⚙️ Como executar
```bash
terraform init
terraform plan
terraform apply -auto-approve
