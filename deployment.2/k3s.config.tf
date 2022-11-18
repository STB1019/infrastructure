resource vault_pki_secret_backend_cert k3s_postgres_crt {
  backend = module.postgres_intermediate.path
  name = module.postgres_intermediate.client_role

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

resource "random_string" "k3s_cluster_token" {
  length           = 128
  special          = false
}

resource local_file k3s_oidc_crt {
  content         = vault_pki_secret_backend_cert.authentik_web_crt.certificate
  filename        = "${var.config_folder}/k3s/k3s.oidc.crt"
  file_permission = 0640
}

resource local_file k3s_config {
  content = templatefile("./config/k3s/install.config.yaml.tpl", {
    kubeconfig_dest = "${var.config_folder}/k3s/kubeconfig.yaml",
    hostname = data.terraform_remote_state.dep.outputs.common_name_domain,
    label_org = data.terraform_remote_state.dep.outputs.org,
    pg_user = postgresql_role.k3s.name,
    pg_db = postgresql_database.k3s.name,
    ca_file = local_file.k3s_pg_ca.filename,
    cert_file = local_file.k3s_pg_cert.filename,
    key_file = local_sensitive_file.k3s_pg_key.filename,
    cluster_token = random_string.k3s_cluster_token.result,
    data_dir = "${var.data_folder}/k3s/",
    cluster_domain = "${data.terraform_remote_state.dep.outputs.common_name_domain}.svc.local",
    oidc_userid_scope = authentik_scope_mapping.userid.scope_name,
    oidc_kube_scope = authentik_scope_mapping.kube.scope_name,
    oidc_ca_file = local_file.k3s_oidc_crt.filename

    oidc_client_id = authentik_provider_oauth2.kube.client_id,
    #TODO
    oidc_issue_url = "https://${data.terraform_remote_state.dep.outputs.common_name_domain}:8443/application/o/${authentik_application.kube.slug}/"
  })
  filename = "${var.config_folder}/k3s/install.config.yaml"
  file_permission = 640
}

resource "random_string" "postgres_k3s_password" {
  length           = 92
  special          = true
  override_special = "!@#$%^&*()_-+="
}

resource postgresql_role k3s {
  name = "k3s"
  login = true
  password = random_string.postgres_k3s_password.result
  depends_on = [
    module.wait_pg
  ]
}

resource "postgresql_database" "k3s" {
  name              = "k3s"
  owner             = postgresql_role.k3s.name
  template          = "template0"
  connection_limit  = -1
  allow_connections = true
}