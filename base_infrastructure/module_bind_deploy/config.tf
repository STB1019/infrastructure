resource random_password tsig_key {
  length           = 128
  special          = true
}

resource local_file bind_config{
    content = templatefile("${path.module}/config/bind.conf", {
        acl_network = var.acl_network,
        zone = var.domain,
        subdomain = var.subdomain,
        app_subdomain = var.app_subdomain,
        forwarders = var.forwarders

        tsig_algorithm = "hmac-sha256",
        tsig_keyname = "dyn.${var.app_subdomain}${var.domain}.",
        tsig_secret = base64sha256(random_password.tsig_key.result),
    })
    filename = "${var.conf_dir}/bind/conf/named.conf"
    file_permission = 0644
}

resource local_file main_zone_config{
    content = templatefile("${path.module}/config/main.zone", {
        zone = "${var.subdomain}${var.domain}",
        machine_ip = var.machine_ip,
        records = join("\n", var.records)
    })
    filename = "${var.data_dir}/bind/zones/${var.subdomain}${var.domain}.zone"
    file_permission = 0640
    depends_on = [
      local_file.app_zone_config
    ]
}

resource local_file app_zone_config{
    content = templatefile("${path.module}/config/app.zone", {
        zone = "${var.app_subdomain}${var.domain}",
        machine_ip = var.machine_ip,
    })
    filename = "${var.data_dir}/bind/zones/${var.app_subdomain}${var.domain}.zone"
    file_permission = 0640
}

resource local_file entrypoint{
    content = templatefile("${path.module}/data/entrypoint.sh", {
        uid = var.user_id
    })
    filename = "${var.data_dir}/bind/entrypoint.sh"
    file_permission = 0755
}