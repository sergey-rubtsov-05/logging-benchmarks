output "user" {
  value = var.user
}

output "password" {
  value = var.password
}

output "host" {
  value = docker_container.postgresql.name
}
