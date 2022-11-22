resource "vault_mount" "pki" {
  path        = "pki_${var.pki_name}"
  type        = "pki"
  description = "${var.pki_name} Intermediate Certificate Authority"
  
  default_lease_ttl_seconds = 2678400 # 31 days
  max_lease_ttl_seconds     = 2678410 # 31 days
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
  backend = var.root_backend
  csr = vault_pki_secret_backend_intermediate_cert_request.pki.csr
  common_name = var.common_name
  exclude_cn_from_sans = false
  ou = var.pki_name
  organization = var.org
  ttl = 31536000 # 365 days
}

resource "vault_pki_secret_backend_intermediate_set_signed" "pki" { 
 backend = vault_mount.pki.path
 certificate = "${vault_pki_secret_backend_root_sign_intermediate.pki.certificate}\n${var.root_bundle}"
}

resource "vault_pki_secret_backend_role" "server" {
  count = var.enable_server ? 1 : 0
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
  country = [var.nation]
  locality = [var.locality]
  province = [var.province]

  max_ttl = 2678410 # 31 days 
  ttl = 2678400 # 31 days
}

resource "vault_pki_secret_backend_role" "client" {
  count = var.enable_client ? 1 : 0
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
  country = [var.nation]
  locality = [var.locality]
  province = [var.province]

  max_ttl = 2678410 # 31 days  
  ttl = 2678400 # 31 days 
}