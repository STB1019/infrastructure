module bind_deploy{
    source = "./module_bind_deploy"
    acl_network = var.acl_network
    domain = var.domain
    conf_dir = var.conf_dir
    data_dir = var.data_dir
    machine_ip = var.machine_ip
    host_cname = var.host_cname
    forwarders = var.forwarders
    network_name = var.network_name
    tsig_algorithm = var.tsig_algorithm
    tsig_keyname = var.tsig_keyname
    tsig_secret = var.tsig_secret
    user_id = var.user_id
}