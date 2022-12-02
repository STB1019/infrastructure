module nginx_deploy{
  source        = "./module_nginx_deploy"
  data_dir      = var.data_dir
  conf_dir      = var.conf_dir

  http_backend = module.http_ca.backend
  server_backend = module.http_ca.server_role
  
  domain        = "${var.subdomain}${var.domain}"
  network_name  = var.network_name
  machine_ip = var.machine_ip
  
  authentik_host = var.authentik_host
  vault_host = var.vault_host
}