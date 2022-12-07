resource "vault_policy" "policy" {
  name = "policy_issuer_${var.issuer_name}"

  policy = <<-EOT
    path "auth/token/lookup-self" {
        capabilities = ["read"]
    }
    path "auth/token/renew-self" {
        capabilities = ["update"]
    }
    path "auth/token/revoke-self" {
        capabilities = ["update"]
    }
    path "${var.pki_path}/sign/${var.pki_role}" {
        capabilities = ["update", "create", "read", "delete", "list"]
    }
EOT
}

resource "vault_token" "token" {
  policies = [
    vault_policy.policy.name
  ]

  renewable = true
  ttl = "31d"
  renew_min_lease = 1296000
  renew_increment = 2592000

  metadata = {
    "purpose" = "service-account"
  }
}