
🛰️ Projeto DHCP com Terraform e Docker

📘 Resumo do Projeto

Este projeto tem como objetivo provisionar automaticamente um servidor DHCP em ambiente Docker, utilizando o Terraform como ferramenta de Infraestrutura como Código (IaC).
O ambiente é executado localmente e simula uma rede onde um servidor DHCP fornece endereços IP dinâmicos para clientes conectados à mesma rede.

🧩 Tecnologias Utilizadas
Tecnologia	Função
Terraform	Criação e gerenciamento automatizado da infraestrutura
Docker	Virtualização de containers para isolar o servidor e os clientes
Ubuntu 22.04	Imagem base do container DHCP
ISC DHCP Server	Serviço DHCP responsável pela distribuição de endereços IP
VS Code	Ambiente de desenvolvimento e execução dos comandos

⚙️ Arquitetura do Ambiente


Terraform

└── Docker Provider
   
    ├── Rede Docker: dhcp_net (bridge)
    
    ├── Container: dhcp_server (servidor DHCP)
   
    ├── Container: client1 (cliente de teste)
    
    └── Container: client2 (cliente de teste)



dhcp_server: executa o serviço ISC DHCP Server configurado para distribuir IPs no range definido em dhcpd.conf.

client1 e client2: simulam máquinas clientes que obtêm IPs automaticamente via DHCP.


📂 Estrutura de Pastas

projeto-dhcp-terraform/

├── main.tf

├── dhcp/

│   ├── Dockerfile

│   └── dhcpd.conf

└── README.md



*.* main.tf → Define toda a infraestrutura com Terraform (rede, containers e permissões).

*.* dhcp/Dockerfile → Cria a imagem personalizada do servidor DHCP.

*.* dhcp/dhcpd.conf → Arquivo de configuração do serviço DHCP.

*.* README.md → Documentação do projeto.


▶️ Execução do Projeto


1°Inicializar o Terraform

   ├── terraform init


2°Aplicar a infraestrutura

   ├── terraform apply -auto-approve


3°Verificar containers em execução

   ├── docker ps


4°Testar o cliente DHCP

   ├── docker exec -it client1 sh
   ├── udhcpc -i eth0
   ├── ip a


🧠 Resultados Esperados


O servidor DHCP inicia com sucesso e escuta na rede dhcp_net.


Os clientes client1 e client2 recebem endereços IP dentro do range configurado.

A comunicação entre os containers ocorre sem conflitos de IPs.

📜 Licença


Projeto desenvolvido para fins educacionais e de demonstração de Infraestrutura como Código (IaC) com Terraform e Docker.

