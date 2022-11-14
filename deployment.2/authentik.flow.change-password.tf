resource "authentik_flow" "password-change-flow" {
  name        = "Cambio Password"
  title       = "Cambio Password"
  slug        = "stb1019-password-change-flow"
  designation = "stage_configuration"
  layout      = "sidebar_left"
  background  = "/bg.jpg"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_flow_stage_binding" "password-change-flow-psw" {
  target = authentik_flow.password-change-flow.uuid
  stage  = data.authentik_stage.default-authentication-password.id
  order  = 20
}


resource "authentik_flow_stage_binding" "password-change-flow-password" {
  target = authentik_flow.password-change-flow.uuid
  stage  = authentik_stage_prompt.password-set-stage.id
  order  = 30
}

resource "authentik_flow_stage_binding" "password-change-flow-write" {
  target = authentik_flow.password-change-flow.uuid
  stage  = data.authentik_stage.default-source-enrollment-write.id
  order  = 30
}
