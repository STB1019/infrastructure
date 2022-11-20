resource vault_pki_secret_backend_cert postgres_server_crt {
  backend = "pki_pg"
  name = "server"

  common_name = "postgres.ieee.elux.ing.unibs.it"
  ip_sans = ["127.0.0.1"]
  auto_renew = true
}

resource local_sensitive_file postgres_key {
  content         = vault_pki_secret_backend_cert.postgres_server_crt.private_key
  filename        = "${var.config_folder}/pg/server.key"
  file_permission = 0600
}

resource local_file postgres_cert {
  content         = "${vault_pki_secret_backend_cert.postgres_server_crt.certificate}\n${vault_pki_secret_backend_cert.postgres_server_crt.ca_chain}"
  filename        = "${var.config_folder}/pg/server.crt"
  file_permission = 0640
}

resource local_file postgres_ca {
  content         = "${vault_pki_secret_backend_cert.postgres_server_crt.ca_chain}"
  filename        = "${var.config_folder}/pg/ca.crt"
  file_permission = 0640
}

module restart_postgres{
    source = "../module_container_sighup"
    container_name = "postgres"

    depends_on = [
      local_file.postgres_ca,
      local_file.postgres_cert,
      local_sensitive_file.postgres_key,
    ]
}