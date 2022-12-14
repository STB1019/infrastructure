variable "data_dir" {
  type        = string
  description = "The directory where the data is stored"
}
variable "network_name" {
  type        = string
  description = "The name of the network to connect to"
}
variable "http_backend" {
  type        = string
  description = "The name of the http backend"
}
variable "server_backend" {
  type = string
}
variable "domain" {
  type = string
}

variable "authentik_host" {
  type = string
}

variable "vault_host" {
  type = string
}

variable "machine_ip" {
  type = string
}
variable "conf_dir" {
  type = string
}

variable "use_http3" {
  type = bool
  default = false
}
