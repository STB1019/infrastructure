resource "tls_private_key" "root_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "tls_self_signed_cert" "root_ca" {
   private_key_pem = tls_private_key.root_ca.private_key_pem

   subject {
     common_name = "${var.domain} Root CA"
     organization = var.org
     organizational_unit = "root"

     locality = var.locality
     province = var.province
     country = var.nation
   }
   validity_period_hours = 876000 #100 years

   allowed_uses = [
     "cert_signing",
     "crl_signing"
   ]

   is_ca_certificate = true 
}

resource "vault_mount" "root" {
  path        = "pki_root"
  type        = "pki"
  description = "Root Certificate Authority"
  default_lease_ttl_seconds = 157680000 # 5 years
  max_lease_ttl_seconds     = 1576800000 # 50 year
}

resource "vault_pki_secret_backend_config_ca" "ca_config" {
  backend  = vault_mount.root.path
  pem_bundle = "${tls_private_key.root_ca.private_key_pem}${tls_self_signed_cert.root_ca.cert_pem}"
}