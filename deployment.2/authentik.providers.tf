resource "authentik_provider_oauth2" "kube" {
  name      = "kube-provider"
  client_id = "kubernetes"
  client_type = "public"
  property_mappings = [
      authentik_scope_mapping.kube.id,
      authentik_scope_mapping.userid.id,
      data.authentik_scope_mapping.openid.id
  ]
  redirect_uris = [".*"]
  authorization_flow = authentik_flow.consent-flow.uuid
  signing_key = authentik_certificate_key_pair.kube.id
}