variable "acl_network" {
  type = string
}

variable "domain"{
  type = string
}
variable "app_subdomain"{
  type = string
}
variable "subdomain"{
  type = string
}

variable "conf_dir" {
  type = string
}

variable "data_dir" {
  type = string
}

variable "machine_ip"{
  type = string
}

variable "forwarders" {
  type = string
}

variable "network_name" {
  type = string
}

variable "tsig_keyname" {
    type = string
}

variable "tsig_secret" {
    type = string
}

variable "tsig_algorithm" {
    type = string
}

variable "user_id"{
  type = string
}

variable "records"{
  type = list(string)
}