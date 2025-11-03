terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

provider "docker" {}

# Cria rede interna
resource "docker_network" "rede_interna" {
  name = var.rede_nome
}

# Cria múltiplas réplicas de apps para alta disponibilidade
resource "docker_container" "apps" {
  for_each = {
    for app in var.containers :
    app.name => app
  }

  count = each.value.replicas

  name  = "${each.key}-${count.index + 1}"
  image = "nginx:alpine"

  networks_advanced {
    name = docker_network.rede_interna.name
  }

  restart = "always"

  healthcheck {
    test     = ["CMD", "wget", "--spider", "http://localhost"]
    interval = "30s"
    timeout  = "10s"
    retries  = 3
  }

  labels = {
    "project" = "Projeto-IFMT"
    "type"    = "app"
    "app"     = each.key
  }
}

# Cria proxy reverso com balanceamento e volume de logs
resource "docker_container" "proxy" {
  name  = "proxy"
  image = var.nginx_image

  ports {
    internal = 80
    external = var.porta_externa
  }

  networks_advanced {
    name = docker_network.rede_interna.name
  }

  volumes = [
    {
      host_path      = abspath("${path.module}/nginx.conf")
      container_path = "/etc/nginx/nginx.conf"
    },
    {
      host_path      = abspath("${path.module}/logs")
      container_path = "/var/log/nginx"
    }
  ]

  restart = "always"

  labels = {
    "project" = "Projeto-IFMT"
    "type"    = "proxy"
  }

  depends_on = [docker_container.apps]
}
