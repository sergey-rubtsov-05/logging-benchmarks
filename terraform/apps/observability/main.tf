module "docker_network" {
  source = "../../modules/docker-network"
  providers = {
    docker = docker
  }
}

module "elastic_stack" {
  source = "../../modules/elastic-stack"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = var.name_prefix
}

module "grafana_stack" {
  source = "../../modules/grafana-stack"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = var.name_prefix
}

module "postgresql" {
  source = "../../modules/postgresql"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = var.name_prefix
}
