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
}
