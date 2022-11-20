terraform {
  required_providers {
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.17.1"
    }
    authentik = {
      source  = "goauthentik/authentik"
      version = "2022.10.0"
    }
  }
}

provider vault {
    address = "https://127.0.0.1:8233"
    token = var.vault_token
    skip_tls_verify = true
}