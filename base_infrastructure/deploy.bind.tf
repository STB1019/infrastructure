module bind_deploy{
    source = "./module_bind_deploy"
    acl_network = var.acl_network
    domain = var.domain
    conf_dir = var.conf_dir
    data_dir = var.data_dir
    machine_ip = var.machine_ip
    forwarders = var.forwarders
    network_name = var.network_name
    user_id = var.user_id
    app_subdomain = var.app_subdomain
    subdomain = var.subdomain
    dns_port = var.dns_port
}