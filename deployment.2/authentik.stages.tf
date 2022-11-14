resource "authentik_stage_identification" "identification-stage" {
  name           = "stb1019-ident-stage"
  user_fields    = ["username", "email"]
  sources        = [authentik_source_oauth.github-source.uuid]
}

data "authentik_stage" "default-authentication-password" {
  name = "default-authentication-password"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

data "authentik_stage" "default-authentication-mfa-validation" {
  name = "default-authentication-mfa-validation"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

data "authentik_stage" "default-authentication-login" {
  name = "default-authentication-login"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

data "authentik_stage" "default-source-enrollment-prompt" {
  name = "default-source-enrollment-prompt"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

data "authentik_stage" "default-source-enrollment-write" {
  name = "default-source-enrollment-write"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

data "authentik_stage" "default-source-enrollment-login" {
  name = "default-source-enrollment-login"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

data "authentik_stage" "default-invalidation-logout" {
  name = "default-invalidation-logout"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

data "authentik_stage" "default-source-authentication-login" {
  name = "default-source-authentication-login"

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}


resource "authentik_stage_prompt" "user-info-stage" {
  name = "user-info-stage"
  fields = [
    authentik_stage_prompt_field.field-name.id,
    authentik_stage_prompt_field.field-surname.id,
    authentik_stage_prompt_field.field-unibs-email.id,
    authentik_stage_prompt_field.field-ieee-email.id,
    authentik_stage_prompt_field.field-ieee-id.id,
  ]
  validation_policies = [
    authentik_policy_expression.policy-validate-ieee-id.id,
    authentik_policy_expression.policy-validate-unibs-email.id,
    authentik_policy_expression.policy-validate-ieee-email.id
  ]
}

resource "authentik_stage_invitation" "invitation-stage" {
  name = "invitation"
  continue_flow_without_invitation = false
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_stage_prompt" "password-set-stage" {
  name = "password-set-stage"
  fields = [
    authentik_stage_prompt_field.field-password.id,
    authentik_stage_prompt_field.field-password-repeat.id,
  ]
  validation_policies = [
    authentik_policy_password.policy-password-strength.id,
  ]
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}