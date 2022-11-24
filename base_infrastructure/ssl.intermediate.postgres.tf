module "pg_ca" {
  source = "./module_intermediate_ca"
  pki_name = "pg"
  org = var.org
  locality = var.locality
  province = var.province
  nation = var.nation

  root_backend = module.root_ca.backend
  root_bundle = module.root_ca.bundle
  common_name = "${var.subdomain}${var.domain}"

  allowed_domains = []
  allowed_uri_sans = ["*"]

  allow_any_name = true
  enforce_hostnames = false

  keytype = "ec"
  keybits = 521

  depends_on = [module.root_ca]
}