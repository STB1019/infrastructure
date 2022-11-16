resource "authentik_flow" "authentication-passwordless-flow" {
  name        = "Accedi a STB1019"
  title       = "Login in STB1019"
  slug        = "stb1019-authentication-passwordless-flow"
  designation = "authentication"
  layout      = "sidebar_left"
  background  = "/bg.jpg"
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_flow_stage_binding" "authentication-passwordless-flow-ident" {
  target = authentik_flow.authentication-passwordless-flow.uuid
  stage  = authentik_stage_authenticator_validate.auth-mfa-pwless-stage.id
  order  = 10
}

resource "authentik_flow_stage_binding" "authentication-passwordless-flow-login" {
  target = authentik_flow.authentication-passwordless-flow.uuid
  stage  = data.authentik_stage.default-authentication-login.id
  order  = 100
}