resource docker_container nginx {
  name      = "nginx"
  hostname  = "nginx"
  image     = var.use_http3 ? docker_image.nginx_http3[0].image_id : docker_image.nginx[0].image_id

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

  volumes{
    container_path  = "/var/www/static"
    host_path       = dirname(local_file.static_dir.filename)
  }

  healthcheck{
    test          = ["CMD", "curl", "http://127.0.0.1:8081"]
    interval      = "30s"
    retries       = 3
    start_period  = "10s"
    timeout       = "15s"
  }

  ports {
    internal = 80
    external = 80
    protocol = "tcp"
  }

  ports {
    internal = 443
    external = 443
    protocol = "tcp"
  }

  dynamic "ports" {
    for_each = range(400, 410, 1)
    content {
      internal = ports.value
      external = ports.value
      protocol = "udp"
    }
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