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

module "app" {
  source = "../../modules/app"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = local.name_prefix
  image = "drimdev/logging-benchmark:v0.1"
  benchmark_type = "ElasticsearchHttpClient"
  elasticsearch_uri = "http://telemetry:9200"
  postgresql_connection_string = "Host=db;Port=5432;Database=web-app;Username=dbuser;Password=dbpassword"
  external_port = 80
}
