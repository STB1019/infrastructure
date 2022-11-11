output vault_container_ip {
  value       = module.wait_vault.container_ip
}

output vault_port {
  value       = var.external_https_port
}

output common_name_domain {
  value       = var.common_name_domain
}

output org {
  value       = var.org
}
