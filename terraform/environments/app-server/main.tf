locals {
  name_prefix = "logging-benchmarks-"
}

module "docker_network" {
  source = "../../modules/docker-network"
  providers = {
    docker = docker
  }
}

module "node-exporter" {
  source = "../../modules/node-exporter"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = local.name_prefix
}

module "otel_collector" {
  source = "../../modules/otel-collector"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = local.name_prefix
  elasticsearch_endpoint = "http://telemetry:9200"
  docker_container_id_to_read_logs_from = module.app.container_id
}

module "app" {
  source = "../../modules/app"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = local.name_prefix
  image = "drimdev/logging-benchmarks:latest"
  benchmark_type = "JsonConsole"
  elasticsearch_uri = "http://telemetry:9200"
  postgresql_connection_string = "Host=db;Port=5432;Database=web-app;Username=dbuser;Password=dbpassword"
  external_port = 80
}
