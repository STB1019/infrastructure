variable pg_backend{
    type = string
}
variable server_backend{
    type = string
}
variable client_backend{
    type = string
}

variable "data_dir" {
  type        = string
  description = "The directory where the data is stored"
}
variable "conf_dir" {
  type = string
}
variable "network_name" {
  type        = string
  description = "The name of the network to connect to"
}

variable "domain" {
  type = string
}
variable "machine_ip" {
  type = string
}
variable user{
    type = string
}

variable admin_user{
  type = string
  default = "postgres"
}

variable admin_db{
  type = string
  default = "postgres"
}