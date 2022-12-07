provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_location
  }
}

provider "vault" {
  address = "https://${var.vault_connection_host}:${var.vault_connection_port}"
  token = var.vault_token
  skip_tls_verify = true
}

provider "kubernetes" {
  config_path    = var.kubeconfig_location
}

terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "kubectl" {
  config_path    = var.kubeconfig_location
}

provider dns {
  update{
    server = var.dns_server
    port = var.dns_port
    key_name      = var.tsig_keyname
    key_algorithm = var.tsig_algo
    key_secret    = var.tsig_secret
  }
}