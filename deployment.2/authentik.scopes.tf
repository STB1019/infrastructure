resource "authentik_scope_mapping" "ieee" {
  name       = "ieee"
  scope_name = "ieee"
  expression = file("./scopes/ieee.py")

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}
resource "authentik_scope_mapping" "unibs" {
  name       = "unibs"
  scope_name = "unibs"
  expression = file("./scopes/unibs.py")

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "vault_token" "authentik_ssh_token" {
  policies = [vault_policy.ssh_policy.name]

  renewable = true
  ttl = "3650d"
  renew_min_lease = 43200
  renew_increment = 86400

  metadata = {
    "purpose" = "ssh"
  }
}
resource "authentik_scope_mapping" "ssh" {
  name       = "ssh"
  scope_name = "ssh"
  expression = templatefile("./scopes/ssh.py.tpl", {
    ssh_token = vault_token.authentik_ssh_token.client_token,
    ssh_client_ep = vault_ssh_secret_backend_role.ssh_client.name,
    vault_ip = "${data.terraform_remote_state.dep.outputs.common_name_domain}:8233"
  })

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}