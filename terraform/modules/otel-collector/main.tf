terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "otel_collector" {
  name = "otel/opentelemetry-collector-contrib:0.115.1"
}

resource "local_file" "otel_collector_config" {
  filename = "${path.module}/configs/otel-collector-config.yml"
  content  = templatefile("${path.module}/templates/otel-collector-config.yml.tpl", {
    name_prefix = var.name_prefix,
  })
}

resource "docker_container" "otel_collector" {
  image = docker_image.otel_collector.name
  name  = "${var.name_prefix}otel-collector"

  user = "0:0"
  privileged = true

  networks_advanced {
    name = var.network_name
  }

  volumes {
    host_path      = abspath("${path.module}/configs/otel-collector-config.yml")
    container_path = "/etc/otelcol-contrib/config.yaml"
  }

  volumes {
    host_path      = "/var/lib/docker/containers"
    container_path = "/var/log/docker"
  }
}
