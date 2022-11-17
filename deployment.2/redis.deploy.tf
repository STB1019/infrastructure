resource random_string redis_password{
  length           = 92
  special          = true
  override_special = "!@#$%^&*()_-+="
}

resource docker_container redis {
  name      = "redis"
  image     = docker_image.redis.image_id

  restart   = "unless-stopped"

  command = [
    "--save", "60", "1", 
    "--loglevel", "warning", 
    "--requirepass", random_string.redis_password.result
  ]
  
  ports{
    internal = 6379
    external = 6379
    ip       = "127.0.0.1"
    protocol = "tcp"
  }

  # user    = var.user

  networks_advanced{
    name = docker_network.nw.name
  }

  healthcheck{
    test          = ["CMD-SHELL", "redis-cli -a '${random_string.redis_password.result}' ping | grep PONG"]
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

module wait_redis {
    source          = "../module_docker_healthy"
    container_name  = docker_container.redis.name
    depends_on      = [docker_container.redis]
}