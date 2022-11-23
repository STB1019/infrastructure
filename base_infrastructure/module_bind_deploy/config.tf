resource local_file bind_config{
    content = templatefile("${path.module}/config/bind.conf", {
        acl_network = var.acl_network,
        zone = var.domain,
        forwarders = var.forwarders
        tsig_algorithm = var.tsig_algorithm,
        tsig_keyname = var.tsig_keyname,
        tsig_secret = var.tsig_secret,
    })
    filename = "${var.conf_dir}/bind/conf/named.conf"
    file_permission = 0644
}

resource local_file zone_config{
    content = templatefile("${path.module}/config/zone", {
        zone = var.domain,
        machine_ip = var.machine_ip,
        host_cname = var.host_cname
    })
    filename = "${var.data_dir}/bind/zones/${var.domain}.zone"
    file_permission = 0640
}

resource local_file entrypoint{
    content = templatefile("${path.module}/data/entrypoint.sh", {
        uid = var.user_id
    })
    filename = "${var.data_dir}/bind/entrypoint.sh"
    file_permission = 0755
}