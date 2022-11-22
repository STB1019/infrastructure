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
    test          = ["CMD", "wget", "http://127.0.0.1:8081", "-O", "-"]
    interval      = "30s"
    retries       = 3
    start_period  = "10s"
    timeout       = "15s"
  }

  ports {
    internal = 80
    external = 80
  }

  ports {
    internal = 443
    external = 443
  }

  ports {
    internal = 8080
    external = 8080
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
