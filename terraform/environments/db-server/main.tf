locals {
  name_prefix = "logging-benchmarks-"
}

module "docker_network" {
  source = "../../modules/docker-network"
  providers = {
    docker = docker
  }
}

module "postgresql" {
  source = "../../modules/postgresql"
  providers = {
    docker = docker
  }
  network_name = module.docker_network.name
  name_prefix = local.name_prefix
}
