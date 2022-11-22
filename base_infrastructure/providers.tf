terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

provider vault {
    address = "http://${module.vault_deploy.container_name}:8200"
    token = module.vault_deploy.token
}