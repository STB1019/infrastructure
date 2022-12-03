resource docker_container bind {
  name      = "bind"
  hostname  = "bind"
  image     = docker_image.bind.image_id

  restart   = "unless-stopped"

  volumes{
    container_path  = "/etc/bind/"
    host_path       = dirname(local_file.bind_config.filename)
    read_only       = true
  }

  volumes{
    container_path  = "/var/lib/bind/"
    host_path       = dirname(local_file.main_zone_config.filename)
  }

  volumes{
    container_path  = "/bin/entrypoint.sh"
    host_path       = local_file.entrypoint.filename
    read_only       = true
  }

  command = ["/bin/entrypoint.sh"]

  ports {
    internal = 53
    external = 53
    protocol = "udp"
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
