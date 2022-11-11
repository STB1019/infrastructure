resource docker_container vault {
  name      = "vault"
  image     = docker_image.vault.image_id

  capabilities{
      add   = ["IPC_LOCK"]
  }

  restart   = "unless-stopped"

  volumes{
    container_path  = "/etc/vault/config.hcl"
    host_path       = local_file.vault_conf.filename
    read_only       = true
  }

  volumes{
    container_path  = "/etc/vault/server.fullchain.pem"
    host_path       = local_file.temp_http_cert.filename
    read_only       = true
  }

  volumes{
    container_path  = "/etc/vault/server.key"
    host_path       = local_sensitive_file.temp_http_key.filename
    read_only       = true
  }

  volumes{
    container_path  = "/vault/file/"
    host_path       = dirname(local_file.vault_data_dir.filename)
  }

  command = ["vault", "server", "-config", "/etc/vault/config.hcl"]
  
  ports{
    internal = var.external_https_port
    external = var.external_https_port
    protocol = "tcp"
  }

  user    = "1000:1000"

  env = [
    "VAULT_ADDR=http://127.0.0.1:${var.internal_http_port}",
    "SKIP_CHOWN=1",
    "SKIP_SETCAP=1"
  ]

  healthcheck{
    test          = ["CMD", "wget", "http://127.0.0.1:${var.internal_http_port}/v1/sys/health", "-O", "-"]
    interval      = "30s"
    retries       = 10
    start_period  = "10s"
    timeout       = "15s"
  }
}

module wait_vault {
    source          = "../module_docker_healthy"
    container_name  = docker_container.vault.name
    depends_on      = [docker_container.vault]
}