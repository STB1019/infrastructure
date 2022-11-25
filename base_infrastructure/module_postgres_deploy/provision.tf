resource vault_pki_secret_backend_cert postgres_provision_crt {
  backend = var.pg_backend
  name = var.client_backend

  common_name = var.admin_user
  auto_renew = true
}

resource local_file pg_provision_crt{
    content = vault_pki_secret_backend_cert.postgres_provision_crt.certificate
    filename = "${var.conf_dir}/pg/provision/postgres.crt"
    file_permission = 0640
}
resource local_file pg_provision_ca{
    content = vault_pki_secret_backend_cert.postgres_provision_crt.ca_chain
    filename = "${var.conf_dir}/pg/provision/postgres.ca.crt"
    file_permission = 0640
}
resource local_sensitive_file pg_provision_key{
    content = vault_pki_secret_backend_cert.postgres_provision_crt.private_key
    filename = "${var.conf_dir}/pg/provision/postgres.key"
    file_permission = 0600
}