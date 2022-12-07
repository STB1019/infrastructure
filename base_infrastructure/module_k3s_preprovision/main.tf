terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2022.10.0"
    }
  }
}

resource random_password cluster_token{
  length = 128
  special = false
}

module k3s_pg_user{
  source = "../module_postgres_user"
  user_name = "k3s"
  pg_backend = var.pg_backend
  client_backend = var.client_backend
}

resource local_sensitive_file k3s_postgres_key {
  content         = module.k3s_pg_user.access.key
  filename        = "${var.conf_dir}/k3s/pg/postgresql.key"
  file_permission = 0600
}

resource local_file k3s_postgres_cert {
  content         = module.k3s_pg_user.access.crt
  filename        = "${var.conf_dir}/k3s/pg/postgresql.crt"
  file_permission = 0640
}

resource local_file k3s_postgres_ca {
  content         = module.k3s_pg_user.access.ca
  filename        = "${var.conf_dir}/k3s/pg/root.crt"
  file_permission = 0640
}

resource local_file k3s_oidc_ca {
  content         = var.http_ca_pem
  filename        = "${var.conf_dir}/k3s/oidc.ca.crt"
  file_permission = 0640
}

resource vault_pki_secret_backend_cert authentik_kube_crt {
  backend = var.oidc_backend
  name = var.oidc_client_backend

  common_name = "kube.${var.domain}"
  ip_sans = ["127.0.0.1", var.machine_ip]
  auto_renew = true
}

resource authentik_certificate_key_pair kube {
  name             = "kube-oidc"
  certificate_data = "${vault_pki_secret_backend_cert.authentik_kube_crt.certificate}\n${vault_pki_secret_backend_cert.authentik_kube_crt.ca_chain}"
  key_data         = vault_pki_secret_backend_cert.authentik_kube_crt.private_key
}

data "authentik_flow" "authorization-flow" {
  slug = "provider-authorization-explicit"
}

data "authentik_flow" "authorization-flow-implicit" {
  slug = "provider-authorization-implicit"
}

data "authentik_scope_mapping" "email" {
  scope_name = "email"
}

data "authentik_scope_mapping" "groups" {
  scope_name = "groups"
}

data "authentik_scope_mapping" "openid" {
  scope_name = "openid"
}

resource "authentik_provider_oauth2" "kube-provider" {
  name      = "kube-provider"
  client_id = "kube"
  authorization_flow = data.authentik_flow.authorization-flow.id
  client_type = "public"
  signing_key = authentik_certificate_key_pair.kube.id
  redirect_uris = [".*"]
  property_mappings = [
    data.authentik_scope_mapping.openid.id,
    data.authentik_scope_mapping.email.id,
    data.authentik_scope_mapping.groups.id,
  ]
}

resource "authentik_application" "kube" {
  name              = "Kubernetes Cluster"
  slug              = "kube-cluster"
  group             = "Kubernetes"
  policy_engine_mode = "all"
  protocol_provider = authentik_provider_oauth2.kube-provider.id
}

data "authentik_group" "member" {
  name = "member"
}

data "authentik_group" "executive" {
  name = "executive"
}

resource "authentik_policy_binding" "kube-access" {
  target = authentik_application.kube.uuid
  group = data.authentik_group.member.id
  negate = false
  order  = 0
}

resource "local_file" "install_config" {
  content = templatefile("${path.module}/install.yaml", {
    kubeconfig_dest = "${var.conf_dir}/k3s/kubeconfig.yaml",
    hostname = var.domain,
    label_org = var.org,
    pg_user = module.k3s_pg_user.user.role,
    pg_db = module.k3s_pg_user.user.db,
    ca_file = local_file.k3s_postgres_ca.filename,
    cert_file = local_file.k3s_postgres_cert.filename,
    key_file = local_sensitive_file.k3s_postgres_key.filename,
    cluster_token = random_password.cluster_token.result,
    data_dir = "${var.data_dir}/k3s/",
    cluster_domain = "${var.domain}.svc.local",
    oidc_userid_scope = "email",
    oidc_kube_scope = "groups",
    oidc_ca_file = local_file.k3s_oidc_ca.filename,
    oidc_issue_url = "https://127.0.0.1:4443/application/o/${authentik_application.kube.slug}/",
    oidc_client_id = authentik_provider_oauth2.kube-provider.client_id,
  })
  filename = "${var.conf_dir}/k3s/install.yaml"
  file_permission = 644
}

