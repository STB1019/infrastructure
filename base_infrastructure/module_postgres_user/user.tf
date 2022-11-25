resource random_password role_pw{
    length = 92
    special = true
}

resource "postgresql_role" "role" {
  name     = var.user_name
  login    = true
  password = random_password.role_pw.result
  superuser = var.superuser
}

resource "postgresql_database" "db" {
  name              = postgresql_role.role.name
  owner             = postgresql_role.role.name
  template          = "template0"
  lc_collate        = "C"
  connection_limit  = -1
  allow_connections = true
}

resource vault_pki_secret_backend_cert crt {
  backend = var.pg_backend
  name = var.client_backend

  common_name = postgresql_role.role.name
  auto_renew = true
  ttl = var.ttl
}
