output certificate {
  value       = "${vault_pki_secret_backend_root_sign_intermediate.pki.certificate}\n${var.root_cert_pem}"
}

output path {
  value       = vault_mount.pki.path
}

output server_role {
  value       = vault_pki_secret_backend_role.server.name
}

output client_role {
  value       = vault_pki_secret_backend_role.client.name
}