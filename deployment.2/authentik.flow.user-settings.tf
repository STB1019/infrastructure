resource "authentik_flow" "user-settings-flow" {
  name        = "Aggiorna i tuoi dati"
  title       = "Aggiorna i tuoi dati"
  slug        = "stb1019-user-settings-flow"
  designation = "stage_configuration"
  layout      = "sidebar_left"
  background  = "/bg.jpg"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_flow_stage_binding" "user-settings-flow-userinfo" {
  target = authentik_flow.user-settings-flow.uuid
  stage  = authentik_stage_prompt.user-info-stage.id
  order  = 20
}

resource "authentik_flow_stage_binding" "user-settings-flow-write" {
  target = authentik_flow.user-settings-flow.uuid
  stage  = data.authentik_stage.default-source-enrollment-write.id
  re_evaluate_policies = true
  order  = 30
}

resource "authentik_policy_binding" "user-settings-flow-write-store" {
  target = authentik_flow_stage_binding.user-settings-flow-write.id
  policy  = authentik_policy_expression.policy-store-attributes.id
  order  = 0
}
