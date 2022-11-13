resource "authentik_flow" "authentication-flow" {
  name        = "Accedi a STB1019"
  title       = "Login in STB1019"
  slug        = "stb1019-authentication-flow"
  designation = "authentication"
  layout      = "sidebar_left"
  background  = "/bg.jpg"
}

resource "authentik_flow_stage_binding" "authentication-flow-ident" {
  target = authentik_flow.authentication-flow.uuid
  stage  = data.authentik_stage.default-authentication-identification.id
  order  = 10
}

resource "authentik_flow_stage_binding" "authentication-flow-psw" {
  target = authentik_flow.authentication-flow.uuid
  stage  = data.authentik_stage.default-authentication-password.id
  order  = 20
}

resource "authentik_flow_stage_binding" "authentication-flow-mfa" {
  target = authentik_flow.authentication-flow.uuid
  stage  = data.authentik_stage.default-authentication-mfa-validation.id
  order  = 30
}

resource "authentik_flow_stage_binding" "authentication-flow-login" {
  target = authentik_flow.authentication-flow.uuid
  stage  = data.authentik_stage.default-authentication-login.id
  order  = 100
}