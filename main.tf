terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Cria uma rede interna Docker
resource "docker_network" "rede_interna" {
  name = "rede_interna"
}

# --- App 1 ---
resource "docker_container" "app1" {
  name  = "app1"
  image = "nginx:alpine"
  networks_advanced {
    name = docker_network.rede_interna.name
  }
}

# --- App 2 ---
resource "docker_container" "app2" {
  name  = "app2"
  image = "nginx:alpine"
  networks_advanced {
    name = docker_network.rede_interna.name
  }
}

# --- App 3 ---
resource "docker_container" "app3" {
  name  = "app3"
  image = "nginx:alpine"
  networks_advanced {
    name = docker_network.rede_interna.name
  }
}

# --- Proxy reverso ---
resource "docker_container" "proxy" {
  name  = "proxy"
  image = "nginx:latest"
  ports {
    internal = 80
    external = 80
  }

  networks_advanced {
    name = docker_network.rede_interna.name
  }

  volumes {
  host_path      = abspath("${path.module}/nginx.conf")
  container_path = "/etc/nginx/nginx.conf"
}


  depends_on = [
    docker_container.app1,
    docker_container.app2,
    docker_container.app3
  ]
}
