module "docker_network" {
  source = "../../modules/docker-network"
  providers = {
    docker = docker
  }
}

locals {
  name_prefix = "logging-benchmarks-"
}

module "elastic_stack" {
  source = "../../modules/elastic-stack"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = local.name_prefix
}

module "grafana_stack" {
  source = "../../modules/grafana-stack"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = local.name_prefix
}

module "postgresql" {
  source = "../../modules/postgresql"
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
}

module "node-exporter" {
  source = "../../modules/node-exporter"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = local.name_prefix
}

module "app" {
  source = "../../modules/app"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = local.name_prefix
  image = "drimdev/logging-benchmark:v0.1"
  benchmark_type = "ElasticsearchHttpClient"
  elasticsearch_uri = "http://${module.elastic_stack.elasticsearch_host}:9200"
  postgresql_connection_string = "Host=${module.postgresql.host};Port=5432;Database=web-app;Username=${module.postgresql.user};Password=${module.postgresql.password}"
  external_port = 8888
}
