# Nome da rede Docker interna
variable "rede_nome" {
  description = "Nome da rede interna Docker"
  default     = "rede_interna"
}

# Lista de containers de aplicação
variable "containers" {
  description = "Lista de containers das aplicações"
  default     = ["app1", "app2", "app3"]
}

# Imagem Docker usada no proxy reverso
variable "nginx_image" {
  description = "Imagem Docker para o proxy reverso"
  default     = "nginx:latest"
}
