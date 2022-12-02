resource docker_container nginx {
  name      = "nginx"
  hostname  = "nginx"
  image     = docker_image.nginx.image_id

  restart   = "unless-stopped"

  volumes{
    container_path  = "/etc/nginx/conf.d"
    host_path       = dirname(local_file.nginx_conf.filename)
    read_only       = true
  }

  volumes{
    container_path  = "/etc/ssl/"
    host_path       = "${var.data_dir}/nginx/ssl"
  }

  healthcheck{
    test          = ["CMD", "curl", "http://127.0.0.1:8081"]
    interval      = "30s"
    retries       = 3
    start_period  = "10s"
    timeout       = "15s"
  }

  ports {
    internal = 4443
    external = 4443
    protocol = "tcp"
  }

  ports {
    internal = 8200
    external = 8200
    protocol = "tcp"
  }

  ports {
    internal = 8080
    external = 8080
    protocol = "tcp"
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

module nginx_wait{
  source = "../module_docker_wait"
  container_name = docker_container.nginx.name
  depends_on = [
    docker_container.nginx
  ]
}