resource vault_pki_secret_backend_cert postgres_server_crt {
  backend = module.postgres_intermediate.path
  name = module.postgres_intermediate.server_role

  common_name = "postgres.${data.terraform_remote_state.dep.outputs.common_name_domain}"
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

resource local_file postgres_conf{
  content         = templatefile("${path.root}/config/postgres/postgres.conf.tpl", {})
  filename        = "${var.config_folder}/pg/postgres.conf"
  file_permission = 0640
}

resource local_file pg_hba_conf{
  content         = templatefile("${path.root}/config/postgres/pg_hba.conf.tpl", {})
  filename        = "${var.config_folder}/pg/pg_hba.conf"
  file_permission = 0640
}

resource local_file postgres_data_dir{
  content         = ""
  filename        = "${var.data_folder}/vault/.keep"
  file_permission = 0640
}

resource "random_string" "postgres_user_password" {
  length           = 64
  special          = true
  override_special = "!@#$%^&*()_-+="
}