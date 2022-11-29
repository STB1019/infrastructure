module vault_deploy{
  source        = "./module_vault_deploy"
  data_dir      = var.data_dir
  conf_dir      = var.conf_dir
  domain        = "${var.vault_host}.${var.subdomain}${var.domain}"
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
  srv_name = "${var.vault_host}.${var.subdomain}${var.domain}"
  reverse_proxy_address = "http://${module.vault_deploy.container_name}:8200"
  use_http3 = true
  http3_port = 402

  depends_on = [module.vault_deploy]
}

resource "dns_cname_record" "vault_dns" {
  zone  = "${var.subdomain}${var.domain}."
  name  = var.vault_host
  cname = "${var.domain}."
}