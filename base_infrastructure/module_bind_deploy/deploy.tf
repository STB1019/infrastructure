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
    external = var.dns_port
    protocol = "udp"
  }

  healthcheck {
    test = ["CMD-SHELL", "echo \"server 127.0.0.1\\nset q=a\\n$(cat /etc/bind/named.conf | sed -n 's/zone *\"\\([a-z\\.\\-]\\+\\)\\.\" *{/ns1.\\1/p')\\nexit\\n\" | nslookup | grep \"server can't find\" && exit 1 || exit 0"]
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

   networks_advanced{
    name = var.network_name
  }
}

module wait_bind {
    source          = "../module_docker_wait"
    container_name  = docker_container.bind.name
    depends_on      = [docker_container.bind]
}