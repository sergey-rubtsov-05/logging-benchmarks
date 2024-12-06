terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_network" "logging_benchmarks" {
  name = var.name
}
