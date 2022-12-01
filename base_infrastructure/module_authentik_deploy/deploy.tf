resource docker_container redis {
  name      = "authentik_redis"
  image     = docker_image.redis.image_id

  restart   = "unless-stopped"

  command = [
    "--save", "60", "1", 
    "--loglevel", "notice", 
    "--requirepass", random_password.redis_password.result
  ]

  networks_advanced {
    name = docker_network.authentik.name
  }

  healthcheck{
    test          = ["CMD-SHELL", "redis-cli -a '${random_password.redis_password.result}' ping | grep PONG"]
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

module wait_redis{
    source = "../module_docker_wait"
    container_name = docker_container.redis.name
    depends_on = [
      docker_container.redis
    ]
}


resource docker_container authentik {
  name      = "authentik-server"
  image     = docker_image.authentik.image_id

  depends_on = [
    local_sensitive_file.authentik_postgres_key,
    local_file.authentik_postgres_cert,
    local_file.authentik_postgres_ca,
    module.wait_redis
  ]

  restart   = "unless-stopped"

  volumes{
    container_path  = "/media"
    host_path       = "${abspath(var.assets_dir)}/media"
  }

  volumes{
    container_path  = "/templates"
    host_path       = "${abspath(var.assets_dir)}/templates"
  }

  volumes{
    container_path  = "/authentik/.postgresql"
    host_path       = "${var.conf_dir}/authentik/pg"
  }

  volumes{
    container_path  = "/blueprints/default"
    host_path       = "${abspath(var.blueprints_dir)}/default"
  }

  volumes{
    container_path  = "/blueprints/system"
    host_path       = "${abspath(var.blueprints_dir)}/system"
  }


  command = ["server"]

  networks_advanced{
    name = var.network_name
  }

  networks_advanced{
    name = docker_network.authentik.name
  }

  env = [
    "AUTHENTIK_REDIS__HOST=${docker_container.redis.name}",
    "AUTHENTIK_POSTGRESQL__HOST=${var.postgres_host}",
    "AUTHENTIK_POSTGRESQL__USER=${module.authentik_pg_user.user.role}",
    "AUTHENTIK_POSTGRESQL__NAME=${module.authentik_pg_user.user.db}",
    "AUTHENTIK_REDIS__PASSWORD=${random_password.redis_password.result}",

    "AUTHENTIK_SECRET_KEY=${random_password.authentik_secret_key.result}",
    "AUTHENTIK_ERROR_REPORTING=false",
    "AUTHENTIK_DEFAULT_USER_CHANGE_USERNAME=false",
    "AUTHENTIK_DEFAULT_TOKEN_LENGTH=128",
    "AUTHENTIK_BOOTSTRAP_PASSWORD=${random_password.akadmin_password.result}",
    "AUTHENTIK_BOOTSTRAP_TOKEN=${random_password.authentik_token.result}",
  ]

  log_driver = "json-file"
  log_opts = {
    "compress" = "true"
    "max-file" = "4"
    "max-size" = "256m"
   }
}

module wait_authentik {
    source          = "../module_docker_wait"
    container_name  = docker_container.authentik.name
    depends_on      = [docker_container.authentik]
}

resource docker_container authentik_worker {
  name      = "authentik-worker"
  image     = docker_image.authentik.image_id

  depends_on = [
    local_sensitive_file.authentik_postgres_key,
    local_file.authentik_postgres_cert,
    local_file.authentik_postgres_ca,
    module.wait_redis
  ]

  restart   = "unless-stopped"

  volumes{
    container_path  = "/media"
    host_path       = "${abspath(var.assets_dir)}/media"
  }

  volumes{
    container_path  = "/templates"
    host_path       = "${abspath(var.assets_dir)}/templates"
  }

  volumes{
    container_path  = "/authentik/.postgresql"
    host_path       = "${var.conf_dir}/authentik/pg"
  }

  volumes{
    container_path  = "/certs"
    host_path       = "${var.conf_dir}/authentik/certs"
  }

  volumes{
    container_path  = "/blueprints/default"
    host_path       = "${abspath(var.blueprints_dir)}/default"
  }

  volumes{
    container_path  = "/blueprints/system"
    host_path       = "${abspath(var.blueprints_dir)}/system"
  }

  volumes{
    container_path  = "/var/run/docker.sock"
    host_path       = "/var/run/docker.sock"
  }

  command = ["worker"]

  networks_advanced{
    name = docker_network.authentik.name
  }

  networks_advanced{
    name = var.network_name
  }


  env = [
    "AUTHENTIK_REDIS__HOST=${docker_container.redis.name}",
    "AUTHENTIK_POSTGRESQL__HOST=${var.postgres_host}",
    "AUTHENTIK_POSTGRESQL__USER=${module.authentik_pg_user.user.role}",
    "AUTHENTIK_POSTGRESQL__NAME=${module.authentik_pg_user.user.db}",
    "AUTHENTIK_REDIS__PASSWORD=${random_password.redis_password.result}",

    "AUTHENTIK_SECRET_KEY=${random_password.authentik_secret_key.result}",
    "AUTHENTIK_ERROR_REPORTING=false",
    "AUTHENTIK_DEFAULT_USER_CHANGE_USERNAME=false",
    "AUTHENTIK_DEFAULT_TOKEN_LENGTH=128",
    "AUTHENTIK_BOOTSTRAP_PASSWORD=${random_password.akadmin_password.result}",
    "AUTHENTIK_BOOTSTRAP_TOKEN=${random_password.authentik_token.result}",
  ]

  log_driver = "json-file"
  log_opts = {
    "compress" = "true"
    "max-file" = "4"
    "max-size" = "256m"
   }
}