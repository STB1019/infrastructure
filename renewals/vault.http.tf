resource vault_pki_secret_backend_cert vault_http_cert {
  backend = "pki_http"
  name = "server"
  common_name = "ieee.elux.ing.unibs.it"
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

module restart_vault{
    source = "../module_container_sighup"
    container_name = "vault"

    depends_on = [
      local_file.vault_cert,
      local_sensitive_file.vault_key,
    ]
}