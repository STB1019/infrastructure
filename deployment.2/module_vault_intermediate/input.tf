variable pki_name {
  type        = string
}
variable org {
  type        = string
}
variable root_path {
  type        = string
}
variable cn {
  type        = string
}
variable allowed_domains {
  type        = list(string)
}
variable allow_any_name {
  type        = bool
}
variable enforce_hostnames {
  type        = bool
}
variable root_cert_pem {
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
