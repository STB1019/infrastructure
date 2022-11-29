resource vault_pki_secret_backend_cert web_crt {
  backend = var.http_backend
  name = var.server_backend
  common_name = "${var.srv_name}"
  ip_sans = ["127.0.0.1", var.machine_ip]
  auto_renew = true
}

resource local_file cert{
  content         = vault_pki_secret_backend_cert.web_crt.certificate
  filename        = "${var.data_dir}/nginx/ssl/${var.srv_name}/server.crt"
  file_permission = 0644
}

resource local_sensitive_file key{
  content         = vault_pki_secret_backend_cert.web_crt.private_key
  filename        = "${var.data_dir}/nginx/ssl/${var.srv_name}/server.key"
  file_permission = 0640
}

resource local_file nginx_conf{
  content         = templatefile("${path.module}/config${var.use_http3 ? "3" : ""}/rev_proxy.conf.tpl", {
    ssl_certificate = "ssl/${var.srv_name}/server.crt",
    ssl_key         = "ssl/${var.srv_name}/server.key"
    srv_name        = var.srv_name,
    reverse_proxy_address = var.reverse_proxy_address,
    additional_configs = var.additional_configs
    port            = var.http3_port
  })
  filename        = "${var.conf_dir}/nginx/${var.srv_name}.conf"
  file_permission = 0644
  depends_on = [
    local_file.cert,
    local_sensitive_file.key
  ]
}