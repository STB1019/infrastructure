variable pki_name {
  type        = string
}
variable org {
  type        = string
}
variable locality {
  type        = string
}
variable province {
  type        = string
}
variable nation {
  type        = string
}
variable root_backend {
  type        = string
}
variable common_name {
  type        = string
}
variable allowed_domains {
  type        = list(string)
}
variable allowed_uri_sans {
  type        = list(string)
}
variable allow_any_name {
  type        = bool
}
variable enforce_hostnames {
  type        = bool
}
variable root_bundle {
  type        = string
}
variable keytype {
  type        = string
  default     = "ec"
}
variable keybits {
  type        = number
  default     = 256
}
variable enable_server {
  type        = bool
  default     = true
}
variable enable_client {
  type        = bool
  default     = true
}

