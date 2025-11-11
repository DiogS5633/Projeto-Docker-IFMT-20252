🛰️ Projeto DHCP com Terraform e Docker
📘 Resumo do Projeto

Este projeto tem como objetivo provisionar automaticamente um servidor DHCP em ambiente Docker utilizando Terraform como ferramenta de Infraestrutura como Código (IaC).
O ambiente é criado localmente, simulando uma rede onde um servidor DHCP fornece endereços IP dinâmicos a clientes conectados.



🧩 Tecnologias Utilizadas
Tecnologia	Função
Terraform	Criação e gerenciamento automatizado da infraestrutura
Docker	Virtualização de containers para isolar o servidor e clientes
Ubuntu 22.04	Imagem base do container DHCP
ISC DHCP Server	Serviço DHCP utilizado para distribuição de endereços IP
VS Code	Ambiente de desenvolvimento e execução dos comandos

⚙️ Arquitetura do Ambiente

  
Terraform

   └── Docker Provider
   
        ├── Rede Docker: dhcp_net (bridge)
        
        ├── Container: dhcp_server (servidor DHCP)
        
        └── Container: client1 (cliente de teste)
        


📂 Estrutura de Pastas

projeto-dhcp-terraform/

├── main.tf

├── dhcp/

│   ├── Dockerfile

│   └── dhcpd.conf

└── README.md

