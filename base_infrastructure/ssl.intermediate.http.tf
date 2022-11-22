module "http_ca" {
  source = "./module_intermediate_ca"
  pki_name = "http"
  org = var.org
  locality = var.locality
  province = var.province
  nation = var.nation

  root_backend = module.root_ca.backend
  root_bundle = module.root_ca.bundle
  common_name = var.domain

  allowed_domains = [var.domain, "localhost", var.machine_ip]
  allowed_uri_sans = ["*.${var.domain}", "*.${var.domain}:*", "${var.domain}:*", "localhost:*", "${var.machine_ip}:*"]

  allow_any_name = false
  enforce_hostnames = true

  keytype = "ec"
  keybits = 521

  enable_client = false

  depends_on = [module.root_ca]
}