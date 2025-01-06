terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "app" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "app" {
  image = docker_image.app.name
  name  = "${var.name_prefix}app"

  networks_advanced {
    name = var.network_name
  }

  env = [
    "ASPNETCORE_URLS=http://+:80",
    "AspireRuntime=false",
    "BenchmarkType=${var.benchmark_type}",
    "Logging__Elasticsearch__ShipTo__NodeUris__0=${var.elasticsearch_uri}",
    "Logging__Elasticsearch__Index__Format=web-app-{0:yyyy.MM.dd}",
    "ConnectionStrings__web-app-db=${var.postgresql_connection_string}",
  ]

  ports {
    internal = 80
    external = var.external_port
  }
}
