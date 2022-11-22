module vault_deploy{
  source        = "./module_vault_deploy"
  data_dir      = var.data_dir
  conf_dir      = var.conf_dir
  domain        = var.domain
  vault_host    = var.vault_host
  network_name  = var.network_name
  user          = var.user
  vault_key_shares = var.vault_key_shares
  vault_key_threshold = var.vault_key_threshold
}

