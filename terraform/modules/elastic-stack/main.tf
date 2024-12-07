terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "elasticsearch" {
  name         = "elasticsearch:8.16.1"
  keep_locally = true
}

resource "docker_volume" "elasticsearch_data" {
  name = "elasticsearch-data"
}

resource "docker_container" "elasticsearch" {
  image = docker_image.elasticsearch.name
  name  = "elasticsearch"

  env = [
    "discovery.type=single-node",
    "bootstrap.memory_lock=true",
    "xpack.security.enabled=false",
    "cluster.routing.allocation.disk.threshold_enabled=false"
  ]

  networks_advanced {
    name = var.network_name
  }

  volumes {
    volume_name    = docker_volume.elasticsearch_data.name
    container_path = "/usr/share/elasticsearch/data"
  }
}

resource "docker_image" "kibana" {
  name         = "kibana:8.16.1"
  keep_locally = true
}

resource "docker_container" "kibana" {
  image = docker_image.kibana.name
  name  = "kibana"

  env = [
    "ELASTICSEARCH_HOSTS=http://elasticsearch:9200"
  ]

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 5601
    external = 5601
  }

  depends_on = [docker_container.elasticsearch]
}
