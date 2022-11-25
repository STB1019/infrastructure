resource vault_pki_secret_backend_cert postgres_server_crt {
  backend = var.pg_backend
  name = var.server_backend

  common_name = "${var.domain}"
  uri_sans = ["${var.domain}", "postgres"]
  ip_sans = ["127.0.0.1", var.machine_ip]
  auto_renew = true
}

resource local_sensitive_file postgres_key {
  content         = vault_pki_secret_backend_cert.postgres_server_crt.private_key
  filename        = "${var.conf_dir}/pg/server.key"
  file_permission = 0600
}

resource local_file postgres_cert {
  content         = "${vault_pki_secret_backend_cert.postgres_server_crt.certificate}\n${vault_pki_secret_backend_cert.postgres_server_crt.ca_chain}"
  filename        = "${var.conf_dir}/pg/server.crt"
  file_permission = 0640
}

resource local_file postgres_ca {
  content         = "${vault_pki_secret_backend_cert.postgres_server_crt.ca_chain}"
  filename        = "${var.conf_dir}/pg/ca.crt"
  file_permission = 0640
}

resource local_file postgres_conf{
  content         = templatefile("${path.module}/config/postgres.conf.tpl", {})
  filename        = "${var.conf_dir}/pg/postgres.conf"
  file_permission = 0640
}

resource local_file pg_hba_conf{
  content         = templatefile("${path.module}/config/pg_hba.conf.tpl", {})
  filename        = "${var.conf_dir}/pg/pg_hba.conf"
  file_permission = 0640
}

resource local_file postgres_passwd{
  content         = templatefile("${path.module}/config/passwd.tpl", {
    user = var.user
  })
  filename        = "${var.conf_dir}/pg/passwd"
  file_permission = 0644
}


resource local_file postgres_data_dir{
  content         = ""
  filename        = "${var.data_dir}/pg/.keep"
  file_permission = 0640
}

resource "random_string" "postgres_user_password" {
  length           = 92
  special          = true
  override_special = "!@#$%^&*()_-+="
}