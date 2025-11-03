variable "rede_nome" {
  description = "Nome da rede Docker interna"
  default     = "rede_interna"
}

variable "porta_externa" {
  description = "Porta exposta do proxy reverso"
  default     = 80
}

variable "nginx_image" {
  description = "Imagem Docker do Nginx proxy"
  default     = "nginx:latest"
}

variable "containers" {
  description = "Lista de aplicações e réplicas"
  type = list(object({
    name     = string
    replicas = number
  }))
  default = [
    { name = "app1", replicas = 2 },
    { name = "app2", replicas = 2 },
    { name = "app3", replicas = 2 }
  ]
}
