module authentik_pg_user{
  source = "../module_postgres_user"
  user_name = "authentik"
  pg_backend = var.pg_backend
  client_backend = var.client_backend
}

resource local_file authentik_passwd {
  content         = templatefile("${path.module}/passwd.tpl", {
    user = var.user
  })
  filename        = "${var.conf_dir}/authentik/passwd"
  file_permission = 0640
}

resource local_sensitive_file authentik_postgres_key {
  content         = module.authentik_pg_user.access.key
  filename        = "${var.conf_dir}/authentik/pg/postgresql.key"
  file_permission = 0600
}

resource local_file authentik_postgres_cert {
  content         = module.authentik_pg_user.access.crt
  filename        = "${var.conf_dir}/authentik/pg/postgresql.crt"
  file_permission = 0640
}

resource local_file authentik_postgres_ca {
  content         = module.authentik_pg_user.access.ca
  filename        = "${var.conf_dir}/authentik/pg/root.crt"
  file_permission = 0640
}

resource "random_password" "akadmin_password" {
  length           = 32
  special          = true
  override_special = "!@#$%^&*()_-+="
}

resource "random_password" "authentik_token" {
  length           = 128
  special          = true
  override_special = "!@#$%^&*()_-+="
}

resource "random_password" "authentik_secret_key" {
  length           = 92
  special          = true
  override_special = "!@#$%^&*()_-+="
}

resource "random_password" "redis_password" {
  length           = 92
  special          = false
}