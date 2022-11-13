resource vault_pki_secret_backend_cert authentik_postgres_crt {
  backend = module.postgres_intermediate.path
  name = module.postgres_intermediate.client_role

  common_name = "authentik"
  ip_sans = ["127.0.0.1"]
}

resource local_sensitive_file authentik_postgres_key {
  content         = vault_pki_secret_backend_cert.authentik_postgres_crt.private_key
  filename        = "${var.config_folder}/authentik/pg/postgresql.key"
  file_permission = 0600
}

resource local_file authentik_postgres_cert {
  content         = "${vault_pki_secret_backend_cert.authentik_postgres_crt.certificate}"
  filename        = "${var.config_folder}/authentik/pg/postgresql.crt"
  file_permission = 0640
}

resource local_file authentik_postgres_ca {
  content         = "${vault_pki_secret_backend_cert.authentik_postgres_crt.ca_chain}"
  filename        = "${var.config_folder}/authentik/pg/root.crt"
  file_permission = 0640
}


resource "random_string" "akadmin_password" {
  length           = 32
  special          = true
  override_special = "!@#$%^&*()_-+="
}

resource "random_string" "authentik_token" {
  length           = 128
  special          = true
  override_special = "!@#$%^&*()_-+="
}

resource "random_string" "authentik_secret_key" {
  length           = 92
  special          = true
  override_special = "!@#$%^&*()_-+="
}