resource vault_pki_secret_backend_cert postgres_provision_crt {
  backend = module.postgres_intermediate.path
  name = module.postgres_intermediate.client_role

  common_name = "postgres"
  ip_sans = ["127.0.0.1"]
  auto_renew = true
}

resource local_sensitive_file postgres_provision_key {
  content         = vault_pki_secret_backend_cert.postgres_provision_crt.private_key
  filename        = "./provision.key"
  file_permission = 0600
}

resource local_file postgres_provision_cert {
  content         = "${vault_pki_secret_backend_cert.postgres_provision_crt.certificate}"
  filename        = "./provision.crt"
  file_permission = 0640
}

resource local_file postgres_provision_ca {
  content         = "${vault_pki_secret_backend_cert.postgres_provision_crt.ca_chain}"
  filename        = "./provision.ca.crt"
  file_permission = 0640
}

provider "postgresql" {
  host            = "127.0.0.1"
  port            = 5432
  database        = "postgres"
  username        = "postgres"
  sslmode         = "require"
  connect_timeout = 15
  clientcert {
    cert = local_file.postgres_provision_cert.filename
    key  = local_sensitive_file.postgres_provision_key.filename
  }
  sslrootcert     = local_file.postgres_provision_ca.filename
}

resource "random_string" "postgres_authentik_password" {
  length           = 92
  special          = true
  override_special = "!@#$%^&*()_-+="
}

resource postgresql_role authentik {
  name = "authentik"
  login = true
  password = random_string.postgres_authentik_password.result
  depends_on = [
    module.wait_pg
  ]
}

resource "postgresql_database" "authentik" {
  name              = "authentik"
  owner             = postgresql_role.authentik.name
  template          = "template0"
  connection_limit  = -1
  allow_connections = true
}