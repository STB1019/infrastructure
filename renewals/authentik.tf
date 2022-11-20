provider authentik {
  url   = "https://127.0.0.1:8443"
  token = var.authentik_token
  insecure = true
}

resource vault_pki_secret_backend_cert authentik_kube_crt {
  backend = "pki_oidc"
  name = "server"

  common_name = "oidc.ieee.elux.ing.unibs.it"
  ip_sans = ["127.0.0.1"]
  uri_sans = ["ieee.elux.ing.unibs.it", "sso.ieee.elux.ing.unibs.it"]
}
resource authentik_certificate_key_pair kube {
  name             = "kube-oidc"
  certificate_data = "${vault_pki_secret_backend_cert.authentik_kube_crt.certificate}\n${vault_pki_secret_backend_cert.authentik_kube_crt.ca_chain}"
  key_data         = vault_pki_secret_backend_cert.authentik_kube_crt.private_key
}

resource vault_pki_secret_backend_cert authentik_postgres_crt {
  backend = "pki_pg"
  name = "client"

  common_name = "authentik"
  ip_sans = ["127.0.0.1"]
  auto_renew = true
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

resource vault_pki_secret_backend_cert authentik_web_crt {
  backend = "pki_http"
  name = "server"

  common_name = "sso.ieee.elux.ing.unibs.it"
  ip_sans = ["127.0.0.1"]
  uri_sans = ["ieee.elux.ing.unibs.it"]
  auto_renew = true
}
resource authentik_certificate_key_pair web {
  name             = "web"
  certificate_data = "${vault_pki_secret_backend_cert.authentik_web_crt.certificate}\n${vault_pki_secret_backend_cert.authentik_web_crt.ca_chain}"
  key_data         = vault_pki_secret_backend_cert.authentik_web_crt.private_key
}

resource "vault_token" "authentik_ssh_token" {
  policies = ["ssh"]

  renewable = true
  ttl = "3650d"
  renew_min_lease = 43200
  renew_increment = 86400
  metadata = {
    "purpose" = "ssh"
  }
}
resource "authentik_scope_mapping" "ssh" {
  name       = "ssh"
  scope_name = "ssh"
  expression = templatefile("../deployment.2/scopes/ssh.py.tpl", {
    ssh_token = vault_token.authentik_ssh_token.client_token,
    ssh_client_ep = "ssh_client_sign",
    vault_ip = "ieee.elux.ing.unibs.it"
  })
}