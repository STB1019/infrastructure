module "root_ca" {
  source = "./module_root_ca"
  domain = var.domain
  org = var.org
  locality = var.locality
  province = var.province
  nation = var.nation
  
  depends_on = [module.vault_deploy]
}