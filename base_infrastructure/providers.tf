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

provider dns {
  update{
    server = module.bind_deploy.container_name
    port = 53
    key_name      = module.bind_deploy.tsig.keyname
    key_algorithm = module.bind_deploy.tsig.algorithm
    key_secret    = module.bind_deploy.tsig.secret
  }
}