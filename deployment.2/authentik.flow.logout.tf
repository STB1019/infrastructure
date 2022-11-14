resource "authentik_flow" "logout-flow" {
  name        = "Disconnessione"
  title       = "Disconnessione"
  slug        = "stb1019-logout-flow"
  designation = "invalidation"
  layout      = "stacked"
  background  = "/bg.jpg"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_flow_stage_binding" "logout-flow-invalidate" {
  target = authentik_flow.logout-flow.uuid
  stage  = data.authentik_stage.default-invalidation-logout.id
  order  = 1
}
