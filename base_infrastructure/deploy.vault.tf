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

resource "dns_cname_record" "vault_dns" {
  zone  = "${var.subdomain}${var.domain}."
  name  = var.vault_host
  cname = "${var.domain}."
  depends_on = [
    module.bind_deploy
  ]
}