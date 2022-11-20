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
  order     = 50
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "field-ieee-id" {
  field_key = "ieee-id"
  label     = "Matricola IEEE"
  type      = "text"
  order     = 60
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "field-unibs-id" {
  field_key = "unibs-id"
  label     = "Matricola UNIBS"
  type      = "text"
  order     = 40
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

resource "authentik_stage_prompt_field" "field-no-save-password" {
  field_key = "__no_save_password"
  label     = "__no_save_password"
  type      = "hidden"
  placeholder = "true"
  order     = 100
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "field-no-save-password-repeat" {
  field_key = "__no_save_password_repeat"
  label     = "__no_save_password_repeat"
  type      = "hidden"
  placeholder = "true"
  order     = 200
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "committee-helper" {
  field_key = "__no_save_committee_helper"
  label     = "committee_helper"
  type      = "static"
  order     = 10
  placeholder = "Selezionare uno tra i seguenti committee:<bl><li>financial: soldi</li><li>membership: gestione membri</li><li>publicity: social e eventi</li></bl>"
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "committee-error-helper" {
  field_key = "__no_save_committee_error_helper"
  label     = "committee_error_helper"
  type      = "static"
  order     = 0
  placeholder = "Hai già scelto un comitato. Questa pagina è ora visibile per motivi di cache. (tra 5 minuti sparirà)"
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt_field" "committee-field" {
  field_key = "committee"
  label     = "Scelta Committee"
  type      = "text"
  order     = 20
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}



