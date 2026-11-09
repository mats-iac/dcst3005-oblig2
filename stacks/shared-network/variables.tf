
variable "kortnavn" {
  description = "Kortnavnet ditt."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]{2,10}$", var.kortnavn))
    error_message = "kortnavn må være 2–10 små bokstaver eller tall."
  }
}

variable "location" {
  description = "Azure-regionen."
  type        = string
}

variable "miljo" {
  description = "Miljøet: dev eller prod."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.miljo)
    error_message = "miljo må være dev eller prod."
  }
}

variable "address_space" {
  description = "Adresserommet til det felles VNet-et."
  type        = list(string)
}
