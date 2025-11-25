terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

############################################
# 1. CRIAÇÃO AUTOMÁTICA DA PASTA DHCP
############################################
resource "null_resource" "create_dhcp_dir" {
  provisioner "local-exec" {
    command = "mkdir -p dhcp"
  }

  triggers = {
    always_run = "${timestamp()}"
  }
}

############################################
# 2. CRIA AUTOMATICAMENTE O DOCKERFILE
############################################
resource "local_file" "dockerfile" {
  depends_on = [null_resource.create_dhcp_dir]

  filename = "${path.module}/dhcp/Dockerfile"

  content = <<-EOF
FROM ubuntu:22.04

RUN apt-get update && \
    apt-get install -y isc-dhcp-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/lib/dhcp && \
    touch /var/lib/dhcp/dhcpd.leases

COPY dhcpd.conf /etc/dhcp/dhcpd.conf

EXPOSE 67/udp

ENTRYPOINT ["/usr/sbin/dhcpd", "-f", "-d", "eth0"]
EOF
}

############################################
# 3. CRIA AUTOMATICAMENTE O dhcpd.conf
############################################
resource "local_file" "dhcpd_conf" {
  depends_on = [null_resource.create_dhcp_dir]

  filename = "${path.module}/dhcp/dhcpd.conf"

  content = <<-EOF
default-lease-time 600;
max-lease-time 7200;
authoritative;

subnet 172.30.0.0 netmask 255.255.255.0 {
    range 172.30.0.10 172.30.0.50;
    option routers 172.30.0.1;
    option subnet-mask 255.255.255.0;
    option domain-name-servers 8.8.8.8;
}
EOF
}

############################################
# 4. CRIA A REDE DOCKER
############################################
resource "docker_network" "dhcp_net" {
  name   = "dhcp_net"
  driver = "bridge"

  ipam_config {
    subnet  = "172.30.0.0/24"
    gateway = "172.30.0.1"
  }
}

############################################
# 5. BUILD AUTOMÁTICO DA IMAGEM DHCP
############################################
resource "docker_image" "dhcp_server" {
  depends_on = [
    local_file.dockerfile,
    local_file.dhcpd_conf
  ]

  name = "custom-dhcp-server"

  build {
    context    = "${path.module}/dhcp"
    dockerfile = "${path.module}/dhcp/Dockerfile"
  }
}

############################################
# 6. CONTAINER DHCP SERVER
############################################
resource "docker_container" "dhcp_server" {
  name  = "dhcp_server"
  image = docker_image.dhcp_server.image_id

  networks_advanced {
    name = docker_network.dhcp_net.name
    ipv4_address = "172.30.0.2"
  }

  restart = "always"
}

############################################
# 7. CLIENTE DHCP 1
############################################
resource "docker_container" "client1" {
  name    = "client1"
  image   = "alpine"
  command = ["sh", "-c", "udhcpc -i eth0 && sleep 3600"]

  capabilities {
    add = ["NET_ADMIN"]
  }

  networks_advanced {
    name = docker_network.dhcp_net.name
  }
}

############################################
# 8. CLIENTE DHCP 2
############################################
resource "docker_container" "client2" {
  name    = "client2"
  image   = "alpine"
  command = ["sh", "-c", "udhcpc -i eth0 && sleep 3600"]

  capabilities {
    add = ["NET_ADMIN"]
  }

  networks_advanced {
    name = docker_network.dhcp_net.name
  }
}
