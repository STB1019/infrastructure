resource vault_pki_secret_backend_cert web_crt {
  backend = var.http_backend
  name = var.server_backend
  common_name = "*.${var.domain}"
  ip_sans = ["127.0.0.1", var.machine_ip]
  auto_renew = true
}

resource local_file nginx_cert{
  content         = vault_pki_secret_backend_cert.web_crt.certificate
  filename        = "${var.data_dir}/nginx/ssl/default/server.crt"
  file_permission = 0644
}

resource local_sensitive_file nginx_key{
  content         = vault_pki_secret_backend_cert.web_crt.private_key
  filename        = "${var.data_dir}/nginx/ssl/default/server.key"
  file_permission = 0640
}

resource local_file static_dir{
  content         = ""
  filename        = "${var.data_dir}/nginx/static/.keep"
  file_permission = 0640
}

resource local_file nginx_inc_rp{
  content         = file("${path.module}/config${var.use_http3 ? "3" : ""}/includes/reverse_proxy.conf")
  filename        = "${var.conf_dir}/nginx/includes/reverse_proxy.conf"
  file_permission = 0644
}


resource local_file nginx_inc_ssl{
  content         = file("${path.module}/config${var.use_http3 ? "3" : ""}/includes/ssl_upstream.conf")
  filename        = "${var.conf_dir}/nginx/includes/ssl_upstream.conf"
  file_permission = 0644
}


resource local_file nginx_conf{
  content         = templatefile("${path.module}/config${var.use_http3 ? "3" : ""}/common.conf.tpl", {
    default_ssl_certificate = "ssl/default/server.crt",
    default_ssl_key         = "ssl/default/server.key",
    domain                  = var.domain,
  })
  filename        = "${var.conf_dir}/nginx/config.conf"
  file_permission = 0644
  depends_on = [
    local_file.nginx_cert,
    local_sensitive_file.nginx_key,
    local_file.nginx_inc_rp,
    local_file.nginx_inc_ssl
  ]
}