variable domain{
    type    = string
}

variable subdomain{
    type    = string
}

variable app_subdomain{
    type    = string
}

variable org{
    type    = string
}

variable locality{
    type    = string
}

variable province{
    type    = string
}

variable nation{
    type    = string
}

variable data_dir{
    type    = string
}

variable assets_dir{
    type    = string
}

variable "blueprints_dir" {
  type = string
}

variable conf_dir{
    type    = string
}

variable user{
    type    = string
}

variable network_name{
    type    = string
}

variable machine_ip{
    type    = string
}

variable dns_port{
    type    = number
}

variable "vault_host"{
    description = "The hostname of the vault server"
    type        = string
}

variable "pg_host"{
    description = "The hostname of the pg server"
    type        = string
}

variable "traeffik_dashboard_dns"{
    description = "The hostname of the traeffik_dashboard_dns server"
    type        = string
}

variable "authentik_host"{
    description = "The hostname of the sso server"
    type        = string
}

variable "vault_key_shares"{
    description = "The number of key shares to use for the vault server"
    type        = number
}

variable "vault_key_threshold"{
    description = "The number of key shares required to unseal the vault server"
    type        = number
}

variable "acl_network" {
  type = string
}

variable "host_cname" {
  type = string
}

variable "forwarders" {
  type = string
  default = "1.1.1.1;\n1.0.0.1;"
}
variable "user_id"{
    type = string
}