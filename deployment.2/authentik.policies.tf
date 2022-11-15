resource "authentik_policy_expression" "policy-validate-ieee-id" {
  name       = "policy-valid-ieee-id"
  expression = file("./policies/validate-ieee-id.py")
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_expression" "policy-validate-unibs-email" {
  name       = "policy-valid-unibs-email"
  expression = templatefile("./policies/validate-email.py.tpl", {
    field_name = "unibs-email"
    email_domain_regex = "@(.+\\\\.)?unibs\\\\.it$"
  })
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_expression" "policy-validate-ieee-email" {
  name       = "policy-valid-ieee-email"
  expression = templatefile("./policies/validate-email.py.tpl", {
    field_name = "ieee-email"
    email_domain_regex = "@ieee\\\\.org$"
  })
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_expression" "policy-validate-name" {
  name       = "policy-valid-name"
  expression = templatefile("./policies/store-attribute.py.tpl", {
    attribute = "nome"
  })
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_expression" "policy-validate-surname" {
  name       = "policy-valid-surname"
  expression = templatefile("./policies/store-attribute.py.tpl", {
    attribute = "cognome"
  })
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_expression" "policy-source-if-username" {
  name       = "policy-source-if-username"
  expression = "return 'username' not in context.get('prompt_data', {})"
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_expression" "policy-source-is-sso" {
  name       = "policy-source-is-sso"
  expression = "return ak_is_sso_flow"
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_expression" "policy-is-gh-org-stb1019" {
  name       = "policy-source-is-sso"
  expression = file("./policies/github-orgs.py")
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_expression" "policy-is-committee-assigned" {
  name       = "policy-is-committee-assigned"
  expression = file("./policies/is-committee-assigned.py")

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_expression" "policy-validate-committee" {
  name       = "policy-validate-committee"
  expression = file("./policies/committee-validation.py")

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_expression" "policy-set-committee" {
  name       = "policy-set-committee"
  expression = file("./policies/committee-set.py")

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_policy_password" "policy-password-strength" {
  name          = "policy-password-strength"
  length_min    = 8
  amount_digits = 1
  amount_symbols = 1
  amount_uppercase = 1
  amount_lowercase = 1
  error_message = "La password deve contenere almeno 8 caratteri contenente lettere minuscole, maiuscole, numeri e simboli"
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}