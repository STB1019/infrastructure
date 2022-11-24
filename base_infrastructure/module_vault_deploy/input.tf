variable data_dir{
    description = "The directory where the vault data will be stored"
    type        = string
}

variable conf_dir{
    description = "The directory where the vault configuration will be stored"
    type        = string
}

variable user{
    type        = string
}

variable network_name{
    description = "The name of the docker network to use"
    type        = string
}

variable domain{
    description = "The domain name to use for the vault server"
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