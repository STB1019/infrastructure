resource "authentik_flow" "committee-select-flow" {
  name        = "Scelta Comitato"
  title       = "Scelta Comitato"
  slug        = "stb1019-committee-select-flow"
  designation = "stage_configuration"
  layout      = "stacked"
  background  = "/bg.jpg"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_binding" "committee-select-flow-access" {
  target = authentik_flow.committee-select-flow.uuid
  group = authentik_group.member.id
  negate = true
  order  = 0
}

resource "authentik_flow_stage_binding" "committee-select-flow-choose" {
  target = authentik_flow.committee-select-flow.uuid
  stage  = authentik_stage_prompt.committee-choose-stage.id
  order  = 10
  evaluate_on_plan = false
  re_evaluate_policies = true
}

resource "authentik_policy_binding" "committee-select-flow-choose-access" {
  target = authentik_flow_stage_binding.committee-select-flow-choose.id
  group = authentik_group.member.id
  negate = true
  order  = 0
}

resource "authentik_flow_stage_binding" "committee-select-flow-write" {
  target = authentik_flow.committee-select-flow.uuid
  stage  = data.authentik_stage.default-source-enrollment-write.id
  evaluate_on_plan = false
  re_evaluate_policies = true
  order  = 40
}

resource "authentik_policy_binding" "committee-select-flow-write-setup" {
  target = authentik_flow_stage_binding.committee-select-flow-write.id
  policy = authentik_policy_expression.policy-set-committee.id
  order  = 0
}


resource "authentik_flow_stage_binding" "committee-select-flow-error" {
  target = authentik_flow.committee-select-flow.uuid
  stage  = authentik_stage_prompt.committee-error-stage.id
  evaluate_on_plan = false
  re_evaluate_policies = true
  order  = 35
}

resource "authentik_policy_binding" "committee-select-flow-error-access" {
  target = authentik_flow_stage_binding.committee-select-flow-error.id
  group = authentik_group.member.id
  order  = 0
}