resource "authentik_flow" "sso-authentication-flow" {
  name        = "Accedi a STB1019"
  title       = "Login in STB1019"
  slug        = "stb1019-sso-authentication-flow"
  designation = "authentication"
  layout      = "stacked"
  background  = "/bg.jpg"
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_flow_stage_binding" "sso-authentication-flow-login" {
  target = authentik_flow.sso-authentication-flow.uuid
  stage  = data.authentik_stage.default-source-authentication-login.id
  order  = 0
}

resource "authentik_policy_binding" "sso-authentication-flow-access" {
  target = authentik_flow.sso-authentication-flow.uuid
  policy = authentik_policy_expression.policy-source-is-sso.id
  order  = 0
}

