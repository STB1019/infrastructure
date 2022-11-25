output "user" {
  value = {
      role = postgresql_role.role.name,
      password = random_password.role_pw.result,
      db = postgresql_database.db.name
  }
}
output "access"{
    value = {
        key = vault_pki_secret_backend_cert.crt.private_key,
        crt = vault_pki_secret_backend_cert.crt.certificate,
        ca = vault_pki_secret_backend_cert.crt.ca_chain
    }
}
