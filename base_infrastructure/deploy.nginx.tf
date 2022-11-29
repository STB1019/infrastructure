module "nginx_deploy" {
  source = "./module_nginx_deploy"
  data_dir = var.data_dir
  conf_dir = var.conf_dir
  domain = "${var.subdomain}${var.domain}"
  network_name = var.network_name
  http_backend = module.http_ca.backend
  server_backend = module.http_ca.server_role
  machine_ip = var.machine_ip
  depends_on = [module.http_ca]
  use_http3 = true
}

resource "dns_cname_record" "host_dns" {
  zone  = "${var.subdomain}${var.domain}."
  name  = "ieeesb"
  cname = "${var.domain}."
}