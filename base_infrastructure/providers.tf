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

provider "dns" {
  update {
    server        = module.bind_deploy.container_name
    port          = 53
    key_name      = "dyn.app.ieee.elux.ing.unibs.it."
    key_algorithm = "hmac-sha256"
    key_secret    = "s5fLido4r/4UTtN6WM3+j7GtyECAVU7mCHtFAl04ex8="
  }
}
