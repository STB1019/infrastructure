variable "domain"{
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

variable "org"{
  type = string
}

variable "pg_backend"{
    type = string
}

variable "client_backend"{
    type = string
}

variable "oidc_backend"{
    type = string
}

variable "oidc_client_backend"{
    type = string
}


variable "http_ca_pem"{
    type = string
}

variable "sso_domain"{
    type = string
}