terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "postgresql" {
  name         = "postgres:17.2"
  keep_locally = true
}

resource "docker_volume" "postgresql_data" {
  name = "${var.name_prefix}postgresql-data"
}

resource "docker_container" "postgresql" {
  image = docker_image.postgresql.name
  name  = "${var.name_prefix}postgresql"

  env = [
    "POSTGRES_USER=${var.user}",
    "POSTGRES_PASSWORD=${var.password}",
  ]

  networks_advanced {
    name = var.network_name
  }

  volumes {
    volume_name    = docker_volume.postgresql_data.name
    container_path = "/var/lib/postgresql/data"
  }

  ports {
    internal = 5432
    external = 5432
  }
}
