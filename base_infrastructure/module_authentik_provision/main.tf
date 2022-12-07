terraform {
  required_providers {
    authentik = {
      source = "goauthentik/authentik"
      version = "2022.10.0"
    }
  }
}

resource "time_sleep" "wait_30_seconds" {
  create_duration = "30s"
}

resource "vault_policy" "ssh_token_policy" {
  name = "ssh-ca-policy"

  policy = <<-EOT
    path "ssh-client-signer/roles/*" {
      capabilities = ["list"]
    } 
    path "ssh/issue/${vault_ssh_secret_backend_role.ssh-role.name}" {
      capabilities = ["create", "update"]
    }
    path "ssh/sign/${vault_ssh_secret_backend_role.ssh-role.name}" {
      capabilities = ["create", "update"]
    }
  EOT
}

resource "vault_token" "ssh-token" {
  policies = [vault_policy.ssh_token_policy.name]

  renewable = false
  ttl = "31d"
  metadata = {
    "purpose" = "service-account"
  }
}


resource "authentik_scope_mapping" "scope-ssh" {
  name       = "scope-ssh"
  scope_name = "ssh"
  expression = <<-EOT
    token = "${vault_token.ssh-token.client_token}"

    ssh_allowed = {
        "membership": [""],
        "publicity": ["ieeesb@ieeesb.unibs.it"],
        "financial": [""],
        "executive": ["webmaster@ieee.elux.ing.unibs.it"]
    }

    _principals = [ssh_allowed[k] if ak_is_group_member(request.user, name=k) else [] for k in ssh_allowed.keys()]
    principals = ["default"]
    for p in _principals:
        principals.extend(p)

    res = requests.post("http://${var.vault_container_name}:8200/v1/${vault_mount.ssh.path}/issue/${vault_ssh_secret_backend_role.ssh-role.name}", json={
        "key_type": "ec",
        "key_bits": 521, 
        "ttl": "4h",
        "valid_principals": ",".join(principals)
    }, headers={
        "X-Vault-Token": token 
    }, verify=False)

    if res.status_code != 200:
        return {
            "ssh": False
        }
    
    data = res.json()

    return {
        "ssh": {
            "private": data['data']['private_key'],
            "public": data['data']['signed_key'],
            "serial": data['data']['serial_number'],
            "principals": principals
        }
    }
  EOT
}