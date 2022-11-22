variable "domain" {
    type = string
    description = "Common name for the root CA"
}

variable "org" {
    type = string
    description = "Organization for the root CA"
}

variable "locality" {
    type = string
    description = "Locality for the root CA"
}

variable "province" {
    type = string
    description = "Province for the root CA"
}

variable "nation" {
    type = string
    description = "Nation for the root CA"
}