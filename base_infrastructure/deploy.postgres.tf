module postgres_deploy{
  source        = "./module_postgres_deploy"
  
  data_dir      = var.data_dir
  conf_dir      = var.conf_dir

  domain        = "${var.pg_host}.${var.subdomain}${var.domain}"

  network_name = var.network_name
  pg_backend = module.pg_ca.backend
  server_backend = module.pg_ca.server_role
  client_backend = module.pg_ca.client_role
  machine_ip = var.machine_ip
  user = var.user
  depends_on = [module.vault_deploy]
}

resource "dns_cname_record" "pg_dns" {
  zone  = "${var.subdomain}${var.domain}."
  name  = var.pg_host
  cname = "${var.domain}."
}