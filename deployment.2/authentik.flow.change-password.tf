resource "authentik_flow" "password-change-flow" {
  name        = "Cambio Password"
  title       = "Cambio Password"
  slug        = "stb1019-password-change-flow"
  designation = "stage_configuration"
  layout      = "stacked"
  background  = "/bg.jpg"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_flow_stage_binding" "password-change-flow-psw" {
  target = authentik_flow.password-change-flow.uuid
  stage  = authentik_stage_password.password-stage.id
  evaluate_on_plan = false
  re_evaluate_policies = true
  policy_engine_mode = "all"
  order  = 10
}

resource "authentik_policy_binding" "password-change-flow-mfa-has-password-policy" {
  target = authentik_flow_stage_binding.password-change-flow-psw.id
  policy = authentik_policy_expression.policy-has-password.id
  order  = 0
}

resource "authentik_policy_binding" "password-change-flow-mfa-nopasswd-policy" {
  target = authentik_flow_stage_binding.password-change-flow-psw.id
  policy = authentik_policy_expression.policy-mfa-no-password.id
  order  = 1
}

resource "authentik_flow_stage_binding" "password-change-flow-mfa" {
  target = authentik_flow.password-change-flow.uuid
  stage  = authentik_stage_authenticator_validate.auth-mfa-stage.id
  order  = 20
}

resource "authentik_flow_stage_binding" "password-change-flow-set-password" {
  target = authentik_flow.password-change-flow.uuid
  stage  = authentik_stage_prompt.password-set-stage.id
  order  = 30
}

resource "authentik_flow_stage_binding" "password-change-flow-write" {
  target = authentik_flow.password-change-flow.uuid
  stage  = data.authentik_stage.default-source-enrollment-write.id
  order  = 40
}
