variable user_name{
    type = string
}

variable superuser{
    type = bool
    default = false
}

variable ttl{
    type = string
    default = "31d"
}

variable "pg_backend" {
  type = string
}
variable "client_backend" {
  type = string
}