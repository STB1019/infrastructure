resource docker_container postgres {
  name      = "postgres"
  image     = docker_image.postgres.image_id

  depends_on = [
    local_sensitive_file.postgres_key,
    local_file.postgres_cert,
    local_file.postgres_ca,
    local_file.postgres_conf,
    local_file.pg_hba_conf,
    local_file.postgres_data_dir
  ]

  restart   = "unless-stopped"

  volumes{
    container_path  = "/etc/pg/"
    host_path       = dirname(local_file.postgres_cert.filename)
    read_only       = true
  }

  volumes{
    container_path  = "/var/lib/postgresql/data/pgdata"
    host_path       = dirname(local_file.postgres_data_dir.filename)
  }

  command = ["-c", "config_file=/etc/pg/postgres.conf"]
  
  ports{
    internal = 5432
    external = 5432
    ip       = "127.0.0.1"
    protocol = "tcp"
  }

  user    = "1000:1000"

  env = [
    "POSTGRES_PASSWORD=${random_string.postgres_user_password.result}",
    "POSTGRES_USER=postgres",
    "POSTGRES_DB=postgres"
  ]
/*
  healthcheck{
    test          = ["CMD", "wget", "http://127.0.0.1:${var.internal_http_port}/v1/sys/health", "-O", "-"]
    interval      = "30s"
    retries       = 10
    start_period  = "10s"
    timeout       = "15s"
  }*/
}
/*
module wait_vault {
    source          = "../module_docker_healthy"
    container_name  = docker_container.vault.name
    depends_on      = [docker_container.vault]
}*/