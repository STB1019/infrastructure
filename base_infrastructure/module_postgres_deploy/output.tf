output "container_name" {
  value = docker_container.postgres.name
}

output "admin_user"{
    value = var.admin_user
}

output "admin_db"{
    value = var.admin_db
}

output "provision"{
  value = {
    key_file = local_sensitive_file.pg_provision_key.filename,
    crt_file = local_file.pg_provision_crt.filename,
    ca_file = local_file.pg_provision_ca.filename,
  }
}