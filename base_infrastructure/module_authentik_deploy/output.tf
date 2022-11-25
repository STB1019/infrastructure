output "container" {
  value = {
      server = docker_container.authentik.name,
      worker = docker_container.authentik_worker.name,
      redis = docker_container.redis.name
  }
}

output "access" {
    value = {
        token = random_password.authentik_token.result,
        admin_psw = random_password.akadmin_password.result
    }
}