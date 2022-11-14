resource "authentik_stage_prompt_field" "field-name" {
  field_key = "nome"
  label     = "Nome"
  type      = "text"
  order     = 10
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "field-surname" {
  field_key = "cognome"
  label     = "Cognome"
  type      = "text"
  order     = 20
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "field-unibs-email" {
  field_key = "unibs-email"
  label     = "Email @*.unibs.it"
  type      = "text"
  order     = 30
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]

}

resource "authentik_stage_prompt_field" "field-ieee-email" {
  field_key = "ieee-email"
  label     = "Email @ieee.org"
  type      = "text"
  order     = 40
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "field-ieee-id" {
  field_key = "ieee-id"
  label     = "Matricola IEEE"
  type      = "text"
  order     = 50
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "field-password" {
  field_key = "password"
  label     = "Password"
  type      = "password"
  order     = 10
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "field-password-repeat" {
  field_key = "password_repeat"
  label     = "Ripeti Password"
  type      = "password"
  order     = 20
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}
