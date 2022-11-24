output "container_name" {
  value = docker_container.bind.name
}

output "container_ip" {
  value = docker_container.bind.network_data[0].ip_address 
}

output "tsig" {
  value = {
    algorithm = "hmac-sha256",
    keyname = "dyn.${var.subdomain}${var.domain}.",
    secret = base64sha256(random_password.subdomain_tsig_key.result)
  }
  sensitive = true
}

output "app_tsig" {
  value = {
    algorithm = "hmac-sha256",
    keyname = "dyn.${var.app_subdomain}${var.domain}.",
    secret = base64sha256(random_password.app_subdomain_tsig_key.result)
  }
  sensitive = true
}