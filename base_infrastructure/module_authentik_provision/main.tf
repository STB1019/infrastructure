terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2022.10.0"
    }
  }
}

resource "authentik_group" "member" {
  name         = "member"
  is_superuser = false
}

resource "authentik_group" "membership" {
  name         = "membership"
  is_superuser = false
  parent       = authentik_group.member.id
}

resource "authentik_group" "financial" {
  name         = "financial"
  is_superuser = false
  parent       = authentik_group.member.id
}

resource "authentik_group" "publicity" {
  name         = "publicity"
  is_superuser = false
  parent       = authentik_group.member.id
}

resource "authentik_group" "executive" {
  name         = "executive"
  is_superuser = true
  parent       = authentik_group.member.id
}

resource vault_pki_secret_backend_cert authentik_web_crt {
  backend = var.http_backend
  name = var.client_backend

  common_name = "ssolocal.${var.domain}"
  ip_sans = ["127.0.0.1"]
}

resource authentik_certificate_key_pair web {
  name             = "web"
  certificate_data = "${vault_pki_secret_backend_cert.authentik_web_crt.certificate}\n${vault_pki_secret_backend_cert.authentik_web_crt.ca_chain}"
  key_data         = vault_pki_secret_backend_cert.authentik_web_crt.private_key
}