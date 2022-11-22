output "bundle" {
  value = "${tls_self_signed_cert.root_ca.cert_pem}"
}

output "certificates" {
  value = tls_self_signed_cert.root_ca.cert_pem
}

output "backend" {
  value = vault_mount.root.path
}

