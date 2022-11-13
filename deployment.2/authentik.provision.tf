provider authentik {
  url   = "https://127.0.0.1:8443"
  token = random_string.authentik_token.result
  insecure = true
}

resource vault_pki_secret_backend_cert authentik_web_crt {
  backend = module.http_intermediate.path
  name = module.http_intermediate.server_role

  common_name = "sso.${data.terraform_remote_state.dep.outputs.common_name_domain}"
  ip_sans = ["127.0.0.1"]
  uri_sans = [data.terraform_remote_state.dep.outputs.common_name_domain]
}

resource authentik_certificate_key_pair web {
  name             = "web"
  certificate_data = "${vault_pki_secret_backend_cert.authentik_web_crt.certificate}\n${vault_pki_secret_backend_cert.authentik_web_crt.ca_chain}"
  key_data         = vault_pki_secret_backend_cert.authentik_web_crt.private_key
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_tenant" "tenant_local_dev" {
  domain              = "${data.terraform_remote_state.dep.outputs.common_name_domain}:8443"
  default             = false
  
  branding_title      = "IEEE SB1019 AuthManager"
  web_certificate     = authentik_certificate_key_pair.web.id

  branding_favicon    = "/media/icon.png"
  branding_logo       = "/media/aside_logo.png"

  flow_authentication = authentik_flow.authentication-flow.uuid
}

