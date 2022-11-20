resource vault_pki_secret_backend_cert k3s_postgres_crt {
  backend = "pki_pg"
  name = "client"

  common_name = "k3s"
  ip_sans = ["127.0.0.1"]
}

resource local_sensitive_file k3s_pg_key {
  content         = vault_pki_secret_backend_cert.k3s_postgres_crt.private_key
  filename        = "${var.config_folder}/k3s/k3s.pg.key"
  file_permission = 0600
}

resource local_file k3s_pg_cert {
  content         = "${vault_pki_secret_backend_cert.k3s_postgres_crt.certificate}"
  filename        = "${var.config_folder}/k3s/k3s.pg.crt"
  file_permission = 0640
}

resource local_file k3s_pg_ca {
  content         = "${vault_pki_secret_backend_cert.k3s_postgres_crt.ca_chain}"
  filename        = "${var.config_folder}/k3s/k3s.pg.ca.crt"
  file_permission = 0640
}