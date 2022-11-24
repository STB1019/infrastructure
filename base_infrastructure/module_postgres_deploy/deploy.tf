resource docker_container postgres {
  name      = "postgres"
  image     = docker_image.postgres.image_id

  depends_on = [
    local_sensitive_file.postgres_key,
    local_file.postgres_cert,
    local_file.postgres_ca,
    local_file.postgres_conf,
    local_file.pg_hba_conf,
    local_file.postgres_data_dir,
    local_file.postgres_passwd
  ]

  restart   = "unless-stopped"

  volumes{
    container_path  = "/etc/pg/"
    host_path       = dirname(local_file.postgres_cert.filename)
    read_only       = true
  }

  volumes{
    container_path  = "/etc/passwd"
    host_path       = local_file.postgres_passwd.filename
    read_only       = true
  }

  volumes{
    container_path  = "/var/lib/postgresql/data"
    host_path       = dirname(local_file.postgres_data_dir.filename)
  }

  command = ["-c", "config_file=/etc/pg/postgres.conf"]
  
  ports{
    internal = 5432
    external = 5432
    protocol = "tcp"
  }

  user    = var.user

  shm_size = 256

  networks_advanced{
    name = var.network_name
  }

  env = [
    "POSTGRES_PASSWORD=${random_string.postgres_user_password.result}",
    "POSTGRES_USER=${var.admin_user}",
    "POSTGRES_DB=${var.admin_db}",
    "PGDATA=/var/lib/postgresql/data/pgdata"
  ]

  healthcheck{
    test          = ["CMD", "pg_isready", "-U", "postgres"]
    interval      = "30s"
    retries       = 4
    start_period  = "10s"
    timeout       = "15s"
  }

  log_driver = "json-file"
  log_opts = {
    "compress" = "true"
    "max-file" = "4"
    "max-size" = "256m"
   }
}

module wait_pg {
    source          = "../module_docker_wait"
    container_name  = docker_container.postgres.name
    depends_on      = [docker_container.postgres]
}