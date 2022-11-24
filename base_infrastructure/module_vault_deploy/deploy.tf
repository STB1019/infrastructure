resource docker_container vault {
  name      = "vault"
  hostname  = "vault"
  image     = docker_image.vault.image_id

  restart   = "unless-stopped"

  volumes{
    container_path  = "/etc/vault/"
    host_path       = dirname(local_file.vault_conf.filename)
    read_only       = true
  }

  volumes{
    container_path  = "/vault/file/"
    host_path       = dirname(local_file.vault_data_dir.filename)
  }

  command = ["vault", "server", "-config", "/etc/vault/config.hcl"]
  
  user    = var.user

  env = [
    "VAULT_ADDR=http://127.0.0.1:8200",
    "SKIP_CHOWN=1",
    "SKIP_SETCAP=1"
  ]

  healthcheck{
    test          = ["CMD", "wget", "http://127.0.0.1:8200/v1/sys/health", "-O", "-"]
    interval      = "30s"
    retries       = 10
    start_period  = "10s"
    timeout       = "15s"
  }

  log_driver = "json-file"
  log_opts = {
    "compress" = "true"
    "max-file" = "4"
    "max-size" = "256m"
   }

   networks_advanced{
    name = var.network_name
  }
}

module vault_unseal{
  source = "../module_vault_init"

  container_name = docker_container.vault.name
  conf_dir       = dirname(local_file.vault_conf.filename)
  vault_key_shares = var.vault_key_shares
  vault_key_threshold = var.vault_key_threshold

  depends_on = [
    docker_container.vault
  ]
}

module vault_wait{
  source = "../module_docker_wait"
  container_name = docker_container.vault.name
  depends_on = [
    module.vault_unseal
  ]
}