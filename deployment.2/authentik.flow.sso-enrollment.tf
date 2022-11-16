resource "authentik_flow" "sso-enrollment-flow" {
  name        = "Iscriviti a STB1019"
  title       = "Iscriviti in STB1019"
  slug        = "stb1019-sso-enrollment-flow"
  designation = "enrollment"
  layout      = "sidebar_left"
  background  = "/bg.jpg"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_binding" "sso-enrollment-flow-access" {
  target = authentik_flow.sso-enrollment-flow.uuid
  policy = authentik_policy_expression.policy-source-is-sso.id
  order  = 0
}


resource "authentik_flow_stage_binding" "sso-enrollment-flow-username" {
  target = authentik_flow.sso-enrollment-flow.uuid
  stage  = data.authentik_stage.default-source-enrollment-prompt.id
  evaluate_on_plan = false
  re_evaluate_policies = true
  order  = 10
}

resource "authentik_policy_binding" "source-sso-enrollment-if-username-policy" {
  target = authentik_flow_stage_binding.sso-enrollment-flow-username.id
  policy = authentik_policy_expression.policy-source-if-username.id
  order  = 0
}

resource "authentik_flow_stage_binding" "sso-enrollment-flow-userinfo" {
  target = authentik_flow.sso-enrollment-flow.uuid
  stage  = authentik_stage_prompt.user-info-stage.id
  order  = 20
}

resource "authentik_flow_stage_binding" "sso-enrollment-flow-write" {
  target = authentik_flow.sso-enrollment-flow.uuid
  stage  = data.authentik_stage.default-source-enrollment-write.id
  re_evaluate_policies = true
  order  = 40
}

resource "authentik_flow_stage_binding" "sso-enrollment-flow-login" {
  target = authentik_flow.sso-enrollment-flow.uuid
  stage  = data.authentik_stage.default-source-enrollment-login.id
  re_evaluate_policies = true
  order  = 50
}

