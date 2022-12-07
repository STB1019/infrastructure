resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  create_namespace = true
  namespace  = "cert-manager"
  wait_for_jobs = true

  set{
    name = "installCRDs"
    value = "true"
  }
}


#workaround for ca certificate
resource "vault_pki_secret_backend_cert" "ca_cert" {
  backend = "pki_http"
  name = "server"
  common_name = "foo.${var.domain}"
}

resource time_sleep "wait_for_cert_manager" {
  depends_on = [helm_release.cert_manager]
  create_duration = "30s"
}

module http_issuer{
  source = "./module_cluster_issuer"

  issuer_name = "http-issuer"
  pki_path = "pki_http"
  pki_role = "server"
  namespace = helm_release.cert_manager.namespace
  vault_connection = "https://${var.vault_connection_host}:${var.vault_connection_port}"
  http_ca_cert = vault_pki_secret_backend_cert.ca_cert.ca_chain

  depends_on = [
    time_sleep.wait_for_cert_manager
  ]
}

module sql_issuer{
  source = "./module_cluster_issuer"

  issuer_name = "sql-issuer"
  pki_path = "pki_pg"
  pki_role = "client"
  namespace = helm_release.cert_manager.namespace
  vault_connection = "https://${var.vault_connection_host}:${var.vault_connection_port}"
  http_ca_cert = vault_pki_secret_backend_cert.ca_cert.ca_chain

  depends_on = [
    time_sleep.wait_for_cert_manager
  ]
}