module bind_deploy{
    source = "./module_bind_deploy"
    acl_network = var.acl_network
    domain = var.domain
    conf_dir = var.conf_dir
    data_dir = var.data_dir
    machine_ip = var.machine_ip
    forwarders = var.forwarders
    network_name = var.network_name
    tsig_algorithm = var.tsig_algorithm
    tsig_keyname = var.tsig_keyname
    tsig_secret = var.tsig_secret
    user_id = var.user_id
    app_subdomain = var.app_subdomain
    subdomain = var.subdomain
    records = [
        "ieeesb IN CNAME ${var.host_cname}",
        "${var.vault_host} IN CNAME ${var.host_cname}"
        ]
}