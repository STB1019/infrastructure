data terraform_remote_state dep {
  backend = "local"
  config = {
    path = "${path.module}/../deployment/terraform.tfstate"
  }
}

provider vault {
    address = "https://${data.terraform_remote_state.dep.outputs.vault_container_ip}:${data.terraform_remote_state.dep.outputs.vault_port}"
    token = var.vault_token
    skip_tls_verify = true
}