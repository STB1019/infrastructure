module vault_deploy{
  source        = "./module_vault_deploy"
  data_dir      = var.data_dir
  conf_dir      = var.conf_dir
  domain        = var.domain
  vault_host    = var.vault_host
  network_name  = var.network_name
  user          = var.user
  vault_key_shares = var.vault_key_shares
  vault_key_threshold = var.vault_key_threshold
}

module vault_ingress{
  source        = "./module_nginx_ingress"
  data_dir      = var.data_dir
  conf_dir      = var.conf_dir
  network_name = var.network_name
  http_backend = module.http_ca.backend
  server_backend = module.http_ca.server_role
  machine_ip = var.machine_ip
  srv_name = "${var.vault_host}.${var.domain}"
  reverse_proxy_address = "http://${module.vault_deploy.container_name}:8200"

  depends_on = [module.vault_deploy]
}

resource "dns_cname_record" "vault_cname" {
  zone  = "${var.domain}."
  name  = var.vault_host
  cname = "${var.host_cname}."

  depends_on = [
    module.bind_deploy,
    module.vault_deploy
  ]
}