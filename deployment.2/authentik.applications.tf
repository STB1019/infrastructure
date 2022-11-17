resource "authentik_application" "setup-committee" {
  name              = "Scelta Comitato"
  slug              = "setup-committee"
  group             = "Benvenuto!"
  meta_description  = ""
  meta_icon         = "/icon.png"
  meta_publisher    = "IEEE SB1019"
  open_in_new_tab   = false

  policy_engine_mode = "all"
  meta_launch_url   = "https://${var.authentik_subdomain}${data.terraform_remote_state.dep.outputs.common_name_domain}:8443/if/flow/${authentik_flow.committee-select-flow.slug}/"
}
resource "authentik_policy_binding" "setup-committee-access" {
  target = authentik_application.setup-committee.uuid
  group = authentik_group.member.id
  negate = true
  order  = 0
}