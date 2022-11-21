variable domain{
    type    = string
}

variable data_dir{
    type    = string
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

variable "vault_host"{
    description = "The hostname of the vault server"
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