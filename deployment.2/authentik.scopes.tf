data "authentik_scope_mapping" "openid" {
  scope_name = "openid"
  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

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

resource "authentik_scope_mapping" "kube" {
  name       = "kube"
  scope_name = "kube"
  expression = file("./scopes/kube.py")

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}

resource "authentik_scope_mapping" "userid" {
  name       = "userid"
  scope_name = "userid"
  expression = file("./scopes/userid.py")

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
    vault_ip = "vault"
  })

  depends_on = [
    module.wait_authentik,
    module.wait_authentik_worker
  ]
}