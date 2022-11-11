resource "vault_mount" "ssh" {
  path        = "ssh"
  type        = "ssh"
  description = "ssh Intermediate Certificate Authority"
  default_lease_ttl_seconds = 473039998
  max_lease_ttl_seconds     = 473039999
}

resource "vault_ssh_secret_backend_ca" "ssh" {
    backend = vault_mount.ssh.path
    generate_signing_key = true
}

resource "vault_ssh_secret_backend_role" "ssh_client" {
    name          = "ssh_client_sign"
    backend       = vault_mount.ssh.path
    key_type      = "ca"
    

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

resource "vault_ssh_secret_backend_role" "ssh_host" {
    name          = "ssh_host_sign"
    backend       = vault_mount.ssh.path
    key_type      = "ca"
    

    algorithm_signer = "rsa-sha2-512"
    allow_host_certificates = true
    ttl = "720h"
    allowed_domains="localdomain,ieee.elux.ing.unibs.it"
    allow_subdomains=true
}