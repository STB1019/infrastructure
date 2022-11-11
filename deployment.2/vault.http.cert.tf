resource vault_pki_secret_backend_cert vault_http_cert {
  backend = module.http_intermediate.path
  name = module.http_intermediate.server_role
  common_name = data.terraform_remote_state.dep.outputs.common_name_domain
  ip_sans = ["127.0.0.1"]
  auto_renew = true
}

resource local_sensitive_file vault_key {
  content         = vault_pki_secret_backend_cert.vault_http_cert.private_key
  filename        = "${var.config_folder}/vault/server.key"
  file_permission = 0600
}


resource local_file vault_cert {
  content         = "${vault_pki_secret_backend_cert.vault_http_cert.certificate}\n${vault_pki_secret_backend_cert.vault_http_cert.ca_chain}"
  filename        = "${var.config_folder}/vault/server.crt"
  file_permission = 0640
}
