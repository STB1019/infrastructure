resource "authentik_flow" "enrollment-flow" {
  name        = "Iscriviti a STB1019"
  title       = "Iscriviti in STB1019"
  slug        = "stb1019-enrollment-flow"
  designation = "enrollment"
  layout      = "sidebar_left"
  background  = "/bg.jpg"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_flow_stage_binding" "enrollment-flow-invitation" {
  target = authentik_flow.enrollment-flow.uuid
  stage  = authentik_stage_invitation.invitation-stage.id
  order  = 1
}

resource "authentik_flow_stage_binding" "enrollment-flow-username" {
  target = authentik_flow.enrollment-flow.uuid
  stage  = data.authentik_stage.default-source-enrollment-prompt.id
  evaluate_on_plan = true
  re_evaluate_policies = true
  order  = 10
}

resource "authentik_policy_binding" "source-enrollment-if-username-policy" {
  target = authentik_flow_stage_binding.enrollment-flow-username.id
  policy = authentik_policy_expression.policy-source-if-username.id
  order  = 0
}

resource "authentik_flow_stage_binding" "enrollment-flow-userinfo" {
  target = authentik_flow.enrollment-flow.uuid
  stage  = authentik_stage_prompt.user-info-stage.id
  re_evaluate_policies = true
  order  = 20
}

resource "authentik_flow_stage_binding" "enrollment-flow-password" {
  target = authentik_flow.enrollment-flow.uuid
  stage  = authentik_stage_prompt.password-set-stage.id
  re_evaluate_policies = true
  order  = 30
}

resource "authentik_flow_stage_binding" "enrollment-flow-write" {
  target = authentik_flow.enrollment-flow.uuid
  stage  = data.authentik_stage.default-source-enrollment-write.id
  re_evaluate_policies = true
  order  = 40
}

resource "authentik_flow_stage_binding" "enrollment-flow-login" {
  target = authentik_flow.enrollment-flow.uuid
  stage  = data.authentik_stage.default-source-enrollment-login.id
  re_evaluate_policies = true
  order  = 50
}

