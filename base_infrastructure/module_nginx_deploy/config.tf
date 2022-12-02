resource vault_pki_secret_backend_cert authentik_crt {
  backend = var.http_backend
  name = var.server_backend
  common_name = "${var.authentik_host}.${var.domain}"
  ip_sans = ["127.0.0.1", var.machine_ip]
  auto_renew = true
}

resource vault_pki_secret_backend_cert vault_crt {
  backend = var.http_backend
  name = var.server_backend
  common_name = "${var.vault_host}.${var.domain}"
  ip_sans = ["127.0.0.1", var.machine_ip]
  auto_renew = true
}


resource local_file nginx_sso_cert{
  content         = vault_pki_secret_backend_cert.authentik_crt.certificate
  filename        = "${var.data_dir}/nginx/ssl/sso/server.crt"
  file_permission = 0644
}

resource local_sensitive_file nginx_sso_key{
  content         = vault_pki_secret_backend_cert.authentik_crt.private_key
  filename        = "${var.data_dir}/nginx/ssl/sso/server.key"
  file_permission = 0640
}

resource local_file nginx_vlt_cert{
  content         = vault_pki_secret_backend_cert.vault_crt.certificate
  filename        = "${var.data_dir}/nginx/ssl/vlt/server.crt"
  file_permission = 0644
}

resource local_sensitive_file nginx_vlt_key{
  content         = vault_pki_secret_backend_cert.vault_crt.private_key
  filename        = "${var.data_dir}/nginx/ssl/vlt/server.key"
  file_permission = 0640
}

resource local_file nginx_conf{
  content         = templatefile("${path.module}/config/common.conf.tpl", {
    sso_ssl_certificate = "ssl/sso/server.crt",
    sso_ssl_key         = "ssl/sso/server.key",
    vlt_ssl_certificate = "ssl/vlt/server.crt",
    vlt_ssl_key         = "ssl/vlt/server.key",
    domain                  = var.domain,
  })
  filename        = "${var.conf_dir}/nginx/config.conf"
  file_permission = 0644
  depends_on = [
    local_file.nginx_sso_cert,
    local_sensitive_file.nginx_sso_key,
    local_file.nginx_vlt_cert,
    local_sensitive_file.nginx_vlt_key
  ]
}