resource docker_container authentik {
  name      = "authentik"
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
    host_path       = "${abspath(path.root)}/../assets/media"
  }

  volumes{
    container_path  = "/templates"
    host_path       = "${abspath(path.root)}/../assets/templates"
  }

  volumes{
    container_path  = "/authentik/.postgresql"
    host_path       = "${var.config_folder}/authentik/pg"
  }

  command = ["server"]
  
  ports{
    internal = 9443
    external = 8443
    protocol = "tcp"
  }

  networks_advanced{
    name = docker_network.nw.name
  }

  env = [
    "AUTHENTIK_REDIS__HOST=${docker_container.redis.name}",
    "AUTHENTIK_POSTGRESQL__HOST=${docker_container.postgres.name}",
    "AUTHENTIK_POSTGRESQL__USER=${postgresql_role.authentik.name}",
    "AUTHENTIK_POSTGRESQL__NAME=${postgresql_database.authentik.name}",
    "AUTHENTIK_REDIS__PASSWORD=${random_string.redis_password.result}",

    "AUTHENTIK_SECRET_KEY=${random_string.authentik_secret_key.result}",
    "AUTHENTIK_ERROR_REPORTING=false",
    "AUTHENTIK_DEFAULT_USER_CHANGE_USERNAME=false",
    "AUTHENTIK_DEFAULT_TOKEN_LENGTH=128",
    "AUTHENTIK_BOOTSTRAP_PASSWORD=${random_string.akadmin_password.result}",
    "AUTHENTIK_BOOTSTRAP_TOKEN=${random_string.authentik_token.result}",
  ]
}

module wait_authentik {
    source          = "../module_docker_healthy"
    container_name  = docker_container.authentik.name
    depends_on      = [docker_container.authentik]
}

resource docker_container authentik_worker {
  name      = "authentik_worker"
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
    host_path       = "${abspath(path.root)}/../assets/media"
  }

  volumes{
    container_path  = "/templates"
    host_path       = "${abspath(path.root)}/../assets/templates"
  }

  volumes{
    container_path  = "/certs"
    host_path       = "${var.config_folder}/authentik/certs"
  }

  volumes{
    container_path  = "/var/run/docker.sock"
    host_path       = "/var/run/docker.sock"
  }

  volumes{
    container_path  = "/authentik/.postgresql"
    host_path       = "${var.config_folder}/authentik/pg"
  }

  command = ["worker"]

  networks_advanced{
    name = docker_network.nw.name
  }

  env = [
    "AUTHENTIK_REDIS__HOST=${docker_container.redis.name}",
    "AUTHENTIK_POSTGRESQL__HOST=${docker_container.postgres.name}",
    "AUTHENTIK_POSTGRESQL__USER=${postgresql_role.authentik.name}",
    "AUTHENTIK_POSTGRESQL__NAME=${postgresql_database.authentik.name}",
    "AUTHENTIK_REDIS__PASSWORD=${random_string.redis_password.result}",

    "AUTHENTIK_SECRET_KEY=${random_string.authentik_secret_key.result}",
    "AUTHENTIK_ERROR_REPORTING=false",
    "AUTHENTIK_DEFAULT_USER_CHANGE_USERNAME=false",
    "AUTHENTIK_DEFAULT_TOKEN_LENGTH=128",
    "AUTHENTIK_BOOTSTRAP_PASSWORD=${random_string.akadmin_password.result}",
    "AUTHENTIK_BOOTSTRAP_TOKEN=${random_string.authentik_token.result}",
  ]
}

module wait_authentik_worker {
    source          = "../module_docker_healthy"
    container_name  = docker_container.authentik_worker.name
    depends_on      = [docker_container.authentik_worker]
}