resource "authentik_application" "setup-committee" {
  name              = "Scelta Comitato"
  slug              = "setup-committee"
  group             = "Benvenuto!"
  meta_description  = ""
  meta_icon         = "/icon.png"
  meta_publisher    = "IEEE SB1019"
  open_in_new_tab   = false

  policy_engine_mode = "all"
  meta_launch_url   = "https://${var.authentik_subdomain}${data.terraform_remote_state.dep.outputs.common_name_domain}:8443/if/flow/${authentik_flow.committee-select-flow.slug}/"
}
resource "authentik_policy_binding" "setup-committee-access" {
  target = authentik_application.setup-committee.uuid
  group = authentik_group.member.id
  negate = true
  order  = 0
}

resource vault_pki_secret_backend_cert authentik_kube_crt {
  backend = module.oidc_intermediate.path
  name = module.oidc_intermediate.server_role

  common_name = "oidc.${data.terraform_remote_state.dep.outputs.common_name_domain}"
  ip_sans = ["127.0.0.1"]
  uri_sans = [data.terraform_remote_state.dep.outputs.common_name_domain, "sso.${data.terraform_remote_state.dep.outputs.common_name_domain}"]
}

resource authentik_certificate_key_pair kube {
  name             = "kube-oidc"
  certificate_data = "${vault_pki_secret_backend_cert.authentik_kube_crt.certificate}\n${vault_pki_secret_backend_cert.authentik_kube_crt.ca_chain}"
  key_data         = vault_pki_secret_backend_cert.authentik_kube_crt.private_key
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}
resource "authentik_application" "kube" {
  name              = "Kubernetes Cluster"
  slug              = "kube-cluster"
  group             = "Kubernetes"
  policy_engine_mode = "all"
  protocol_provider = authentik_provider_oauth2.kube.id
}
resource "authentik_policy_binding" "kube-access" {
  target = authentik_application.kube.uuid
  group = authentik_group.member.id
  negate = false
  order  = 0
}