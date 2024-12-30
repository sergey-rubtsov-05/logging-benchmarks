terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "node_exporter" {
  name         = "prom/node-exporter:v1.8.2"
  keep_locally = true
}

resource "docker_container" "node_exporter" {
  image = docker_image.node_exporter.name
  name  = "${var.name_prefix}node-exporter"

  networks_advanced {
    name = var.network_name
  }

  volumes {
    host_path      = "/proc"
    container_path = "/host/proc"
    read_only      = true
  }

  volumes {
    host_path      = "/sys"
    container_path = "/host/sys"
    read_only      = true
  }

  volumes {
    host_path      = "/"
    container_path = "/rootfs"
    read_only      = true
  }

  command = [
    "--path.procfs=/host/proc",
    "--path.sysfs=/host/sys",
    "--path.rootfs=/rootfs",
    "--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)",
  ]

  ports {
    internal = 9100
    external = 9100
  }
}
