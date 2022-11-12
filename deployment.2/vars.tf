variable config_folder {
  type        = string
  description = "container config folder"
}

variable data_folder {
  type        = string
  description = "container data folder"
}

variable user {
  type        = string
  default     = "1000:1000"
}