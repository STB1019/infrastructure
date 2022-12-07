resource "vault_mount" "ssh" {
  type = "ssh"
  path = "ssh"
  default_lease_ttl_seconds = 3600 # 1h
  max_lease_ttl_seconds = 14400 # 4h
  description = "SSH Certificate Authority"
}

resource "vault_ssh_secret_backend_ca" "ssh-ca" {
  backend = vault_mount.ssh.path
  generate_signing_key = true
}

resource "vault_ssh_secret_backend_role" "ssh-role" {
    name                    = "client"
    backend       = vault_mount.ssh.path
    key_type                = "ca"

    algorithm_signer = "rsa-sha2-512"
    allow_user_certificates = true
    allowed_users = "*"
    allowed_extensions = "permit-pty,permit-port-forwarding"
    default_extensions = {
      permit-pty = ""
    }
    default_user = "default"
    ttl = "30m0s"
}

resource "vault_ssh_secret_backend_role" "ssh-host-role" {
    name          = "server"
    backend       = vault_mount.ssh.path
    key_type      = "ca"
    algorithm_signer = "rsa-sha2-512"
    allow_host_certificates = true
    ttl = "720h"
    allowed_domains="localdomain,unibs.it"
    allow_subdomains=true
}
