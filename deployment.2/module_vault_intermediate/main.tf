resource "vault_mount" "pki" {
  path        = "pki_${var.pki_name}"
  type        = "pki"
  description = "${var.pki_name} Intermediate Certificate Authority"
  
  default_lease_ttl_seconds = 473039998
  max_lease_ttl_seconds     = 473039999
}

resource "vault_pki_secret_backend_intermediate_cert_request" "pki" {
  backend = vault_mount.pki.path
  type = "internal"
  common_name = "${var.pki_name} ${var.org} Intermediate Certificate"
  format = "pem"
  private_key_format = "der"

  key_type = var.keytype
  key_bits = var.keybits
}

resource "vault_pki_secret_backend_root_sign_intermediate" "pki" {
  backend = var.root_path
  csr = vault_pki_secret_backend_intermediate_cert_request.pki.csr
  common_name = var.cn
  exclude_cn_from_sans = true
  ou = var.pki_name
  organization = var.org
  ttl = 473039998
}

resource "vault_pki_secret_backend_intermediate_set_signed" "pki" { 
 backend = vault_mount.pki.path
 certificate = "${vault_pki_secret_backend_root_sign_intermediate.pki.certificate}\n${var.root_cert_pem}"
}

resource "vault_pki_secret_backend_role" "server" {
  backend = vault_mount.pki.path
  name = "server"

  allowed_domains = var.allowed_domains
  allow_subdomains = true
  allow_bare_domains = true
  allow_glob_domains = true
  allow_any_name = var.allow_any_name
  enforce_hostnames = var.enforce_hostnames
  allow_ip_sans = true
  allowed_uri_sans = var.allowed_uri_sans

  server_flag = true
  client_flag = false 
  key_type = var.keytype
  key_bits = var.keybits

  ou = [var.pki_name]
  organization = [var.org]
  
  country = ["IT"]
  locality = ["Brescia"]
  max_ttl = 63113904 
  ttl = 2592000
}

resource "vault_pki_secret_backend_role" "client" {
  backend = vault_mount.pki.path
  name = "client"

  allowed_domains = var.allowed_domains
  allow_subdomains = true
  allow_bare_domains = true
  allow_glob_domains = true
  allow_any_name = var.allow_any_name
  enforce_hostnames = var.enforce_hostnames
  allow_ip_sans = true
  allowed_uri_sans = var.allowed_uri_sans

  server_flag = false
  client_flag = true 
  key_type = var.keytype
  key_bits = var.keybits

  ou = [var.pki_name]
  organization = [var.org]
  country = ["IT"]
  locality = ["Brescia"]

  max_ttl = 63113904 
  ttl = 2592000
}