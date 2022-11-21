data "external" "init_vault" {
  program = [
    "${path.module}/vault_init.sh", 
    var.container_name, 
    "${var.conf_dir}",
    var.vault_key_shares,
    var.vault_key_threshold,
  ]
}