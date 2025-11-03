terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Cria a rede interna Docker
resource "docker_network" "rede_interna" {
  name = var.rede_nome
}

# Cria containers das aplicações (app1, app2, app3)
resource "docker_container" "apps" {
  for_each = toset(var.containers)

  name  = each.key
  image = "nginx:alpine"

  networks_advanced {
    name = docker_network.rede_interna.name
  }

  labels = {
    "project" = "Projeto-IFMT"
    "author"  = "Diogo Mendoza"
    "type"    = "app"
  }
}

# Cria o container proxy reverso (Nginx)
resource "docker_container" "proxy" {
  name  = "proxy"
  image = var.nginx_image

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

  labels = {
    "project" = "Projeto-IFMT"
    "author"  = "Diogo Mendoza"
    "type"    = "proxy"
  }

  depends_on = [docker_container.apps]
}
