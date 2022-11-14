variable config_folder {
  type        = string
  description = "container config folder"
}

variable data_folder {
  type        = string
  description = "container data folder"
}

variable common_name_domain {
  type        = string
  default     = "ieee.elux.ing.unibs.it"
  description = "Desinenza dei common name"
}

variable org {
  type        = string
  default     = "ieeesb1019"
  description = "Desinenza dei common name"
}


variable user {
  type        = string
  default     = "1000:1000"
}