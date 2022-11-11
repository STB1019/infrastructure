resource "vault_mount" "root" {
  path        = "pki_root"
  type        = "pki"
  description = "Root Certificate Authority"
  default_lease_ttl_seconds = 473040000
  max_lease_ttl_seconds     = 473040001
}

resource "vault_pki_secret_backend_config_ca" "ca_config" {
  backend  = vault_mount.root.path
  pem_bundle = "${tls_private_key.root_ca.private_key_pem}${tls_self_signed_cert.root_ca.cert_pem}"
}