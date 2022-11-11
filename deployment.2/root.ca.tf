resource "tls_private_key" "root_ca" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P521"
}

resource "tls_self_signed_cert" "root_ca" {
   private_key_pem = tls_private_key.root_ca.private_key_pem

   subject {
     common_name = "${data.terraform_remote_state.dep.outputs.common_name_domain} Root CA"
     organization = data.terraform_remote_state.dep.outputs.org
     organizational_unit = "root"

     locality = var.locality
     province = var.province
     country = var.nation
   }
   validity_period_hours = 175200

   allowed_uses = [
     "cert_signing",
     "crl_signing"
   ]

   is_ca_certificate = true 
}
