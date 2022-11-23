resource local_file vault_conf{
  content         = templatefile("${path.module}/config/config.hcl.tpl", {
    vault_domain  = "${var.vault_host}.${var.domain}"
    http_port     = "8200"
  })
  filename        = "${var.conf_dir}/vault/config.hcl"
  file_permission = 0640
}

resource local_file vault_data_dir{
  content         = ""
  filename        = "${var.data_dir}/vault/.keep"
  file_permission = 0640
}