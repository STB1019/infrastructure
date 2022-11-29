module authentik_deploy{
    source = "./module_authentik_deploy"
    
    pg_backend = module.pg_ca.backend
    client_backend = module.pg_ca.client_role
    assets_dir = var.assets_dir
    blueprints_dir = var.blueprints_dir
    postgres_host = module.postgres_deploy.container_name

    network_name = var.network_name
    conf_dir = var.conf_dir
    data_dir = var.data_dir
    depends_on = [
      module.postgres_deploy
    ]
}

module authentik_ingress{
  source        = "./module_nginx_ingress"
  data_dir      = var.data_dir
  conf_dir      = var.conf_dir
  network_name = var.network_name
  http_backend = module.http_ca.backend
  server_backend = module.http_ca.server_role
  machine_ip = var.machine_ip
  srv_name = "${var.authentik_host}.${var.subdomain}${var.domain}"
  reverse_proxy_address = "http://${module.authentik_deploy.container.server}:9000"
  use_http3 = true
  http3_port = 403

  depends_on = [module.vault_deploy, module.authentik_deploy]
}

resource "dns_cname_record" "authentik_dns" {
  zone  = "${var.subdomain}${var.domain}."
  name  = var.authentik_host
  cname = "${var.domain}."
}