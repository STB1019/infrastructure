variable "domain"  { type = string }

variable "remote_machine_ip"  { type = string }
variable "kubeconfig_location"  { type = string }
variable "vault_connection_host"  { type = string }
variable "vault_connection_port"  { type = number }
variable "authentik_connection_host"  { type = string }
variable "authentik_connection_port"  { type = number }
variable "vault_token"  { type = string }
variable "authentik_token"  { type = string }

variable "tsig_secret"  { type = string }
variable "tsig_keyname"  { type = string }
variable "tsig_algo"  { type = string }
variable "dns_server"  { type = string }
variable "dns_port"  { type = number }

variable machine_ip{ type = string }
variable machine_cname{ type = string }
