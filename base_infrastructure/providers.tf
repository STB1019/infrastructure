terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.0"
    }
    postgresql = {
      source = "cyrilgdn/postgresql"
      version = "1.17.1"
    }
    authentik = {
      source = "goauthentik/authentik"
      version = "2022.10.0"
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

provider "postgresql" {
  host            = module.postgres_deploy.container_name
  port            = 5432
  username        = module.postgres_deploy.admin_user
  sslmode         = "verify-ca"
  clientcert {
    cert = module.postgres_deploy.provision.crt_file
    key  = module.postgres_deploy.provision.key_file
  }
  sslrootcert = module.postgres_deploy.provision.ca_file
}

provider authentik {
  url   = "http://${module.authentik_deploy.container.server}:9000"
  token = module.authentik_deploy.access.token
}