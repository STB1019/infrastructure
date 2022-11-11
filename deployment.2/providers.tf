data terraform_remote_state dep {
  backend = "local"
  config = {
    path = "${path.module}/../deployment/terraform.tfstate"
  }
}

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
    address = "https://${data.terraform_remote_state.dep.outputs.vault_container_ip}:${data.terraform_remote_state.dep.outputs.vault_port}"
    token = var.vault_token
    skip_tls_verify = true
}