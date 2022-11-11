output certificate {
  value       = "${vault_pki_secret_backend_root_sign_intermediate.pki.certificate}\n${var.root_cert_pem}"
}
