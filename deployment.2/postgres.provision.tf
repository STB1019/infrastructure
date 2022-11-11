resource vault_pki_secret_backend_cert postgres_provision_crt {
  backend = module.postgres_intermediate.path
  name = module.postgres_intermediate.client_role

  common_name = "postgres"
}