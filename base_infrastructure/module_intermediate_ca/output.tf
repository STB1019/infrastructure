output bundle {
  value       = "${vault_pki_secret_backend_intermediate_set_signed.pki.certificate}"
}

output certificate {
  value       = "${vault_pki_secret_backend_intermediate_set_signed.pki.certificate}"
}

output backend {
  value       = vault_mount.pki.path
}

output server_role {
  value       = var.enable_server ? vault_pki_secret_backend_role.server[0].name : "-"
}

output client_role {
  value       = var.enable_client ? vault_pki_secret_backend_role.client[0].name : "-"
}