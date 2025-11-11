terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# ----------------------------
# Rede Docker para o DHCP
# ----------------------------
resource "docker_network" "dhcp_net" {
  name   = "dhcp_net"
  driver = "bridge"

  ipam_config {
    subnet  = "172.30.0.0/24"  # Mudamos para evitar conflito
    gateway = "172.30.0.1"
  }
}

# ----------------------------
# Imagem do servidor DHCP
# ----------------------------
resource "docker_image" "dhcp_server" {
  name = "custom-dhcp-server"

  build {
    context    = "${path.module}/dhcp"
    dockerfile = "${path.module}/dhcp/Dockerfile"
  }
}

# ----------------------------
# Container do servidor DHCP
# ----------------------------
resource "docker_container" "dhcp_server" {
  name  = "dhcp_server"
  image = docker_image.dhcp_server.image_id

  networks_advanced {
    name = docker_network.dhcp_net.name
  }

  restart = "always"
}

# Cliente DHCP para teste
resource "docker_container" "client1" {
  name    = "client1"
  image   = "alpine"
  command = ["sleep", "3600"]

  networks_advanced {
    name = docker_network.dhcp_net.name
  }
}

# Cliente DHCP para teste
resource "docker_container" "client2" {
  name    = "client2"
  image   = "alpine"
  command = ["sleep", "3600"]

  networks_advanced {
    name = docker_network.dhcp_net.name
  }
}
