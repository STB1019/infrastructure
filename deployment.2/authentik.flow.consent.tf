resource "authentik_flow" "consent-flow" {
  name        = "Autorizza %(app)s"
  title       = "Autorizza %(app)s"
  slug        = "stb1019-consent-flow"
  designation = "authorization"
  layout      = "stacked"
  background  = "/bg.jpg"
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_flow_stage_binding" "authentication-flow-consent" {
  target = authentik_flow.consent-flow.uuid
  stage  = authentik_stage_consent.explicit-consent-stage.id
  order  = 10
}