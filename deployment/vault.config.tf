resource tls_private_key temp_http {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource tls_self_signed_cert temp_http {
  private_key_pem         = tls_private_key.temp_http.private_key_pem

  subject {
    common_name           = "vault.temp.local"
    organization          = "vault temp certificate"
  }

  validity_period_hours   = 24

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource local_sensitive_file temp_http_key {
  content         = tls_private_key.temp_http.private_key_pem
  filename        = "${var.config_folder}/vault/server.key"
  file_permission = 0600
}

resource local_file temp_http_cert {
  content         = tls_self_signed_cert.temp_http.cert_pem
  filename        = "${var.config_folder}/vault/server.crt"
  file_permission = 0640
}

resource local_file vault_conf{
  content         = templatefile("${path.root}/config/vault/config.hcl.tpl", {
    internal_http_port  = var.internal_http_port
    external_https_port = var.external_https_port
    vault_host          = var.vault_host
  })
  filename        = "${var.config_folder}/vault/config.hcl"
  file_permission = 0640
}

resource local_file vault_data_dir{
  content         = ""
  filename        = "${var.data_folder}/vault/.keep"
  file_permission = 0640
}

#hvs.iuJn3A7lv3uBcmN75leY7vjM
#0htFTQqbFDJG6s3PdGzDl+5MRpPWH9fY2k4X2rbsALs=