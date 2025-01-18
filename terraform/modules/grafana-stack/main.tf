terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
    }
  }
}

resource "local_file" "prometheus_config" {
  filename = abspath("${path.module}/configs/prometheus.yml")
  content  = <<EOT
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
${join(",\n", [for target in var.prometheus_targets : <<EOL
  - job_name: "${target.job_name}"
    scrape_interval: "${lookup(target, "scrape_interval", "15s")}"
    static_configs:
      - targets:
${join("\n", [for t in target.targets : "          - \"${t}\""])}
EOL
])}
EOT
}

resource "docker_image" "prometheus" {
  name         = "prom/prometheus:v3.0.1"
  keep_locally = true
}

resource "docker_volume" "prometheus_data" {
  name = "${var.name_prefix}prometheus-data"
}

resource "docker_container" "prometheus" {
  image = docker_image.prometheus.name
  name  = "${var.name_prefix}prometheus"

  networks_advanced {
    name = var.network_name
  }

  command = [
    "--config.file=/etc/prometheus/prometheus.yml",
    "--storage.tsdb.path=/prometheus"
  ]

  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  volumes {
    host_path      = local_file.prometheus_config.filename
    container_path = "/etc/prometheus/prometheus.yml"
  }

  ports {
    internal = 9090
    external = 9090
  }
}

resource "docker_image" "grafana" {
  name         = "grafana/grafana:11.4.0"
  keep_locally = true
}

resource "local_file" "grafana_prometheis_datasource" {
  filename = "${path.module}/configs/grafana-provisioning/datasources/prometheus.yml"
  content  = templatefile("${path.module}/templates/grafana-datasources.yml.tpl", {
    name_prefix = var.name_prefix,
  })
}

resource "docker_volume" "grafana_data" {
  name = "${var.name_prefix}grafana-data"
}

resource "docker_container" "grafana" {
  image = docker_image.grafana.name
  name  = "${var.name_prefix}grafana"

  networks_advanced {
    name = var.network_name
  }

  ports {
    internal = 3000
    external = 3000
  }

  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  volumes {
    host_path      = abspath("${path.module}/configs/grafana-provisioning")
    container_path = "/etc/grafana/provisioning"
  }

  volumes {
    host_path      = abspath("${path.module}/dashboards")
    container_path = "/var/lib/grafana/dashboards"
  }

  env = [
    "GF_SECURITY_ADMIN_USER=admin",
    "GF_SECURITY_ADMIN_PASSWORD=admin",
  ]

  depends_on = [docker_container.prometheus]
}
