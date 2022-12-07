resource "dns_cname_record" "vault_dns" {
  zone  = "${var.domain}."
  name  = var.hostname
  cname = "${var.machine_cname}."
}