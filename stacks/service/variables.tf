
variable "kortnavn" {
  description = "Kortnavn brukt i Azure-ressursnavn."
  type        = string
}

variable "location" {
  description = "Azure-region."
  type        = string
}

variable "miljo" {
  description = "Miljø: dev eller prod."
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.miljo)
    error_message = "miljo må være dev eller prod."
  }
}

variable "service" {
  description = "Tjenestens navn, for eksempel ordre eller meny."
  type        = string
}

variable "runtime" {
  description = "Kjøremiljø: vm eller webapp."
  type        = string

  validation {
    condition     = contains(["vm", "webapp"], var.runtime)
    error_message = "runtime må være vm eller webapp."
  }
}

variable "subnet_prefix" {
  description = "Adresseområdet til tjenestens subnett."
  type        = string
}

variable "allow_http_from" {
  description = "Tillatt kilde for HTTP-trafikk."
  type        = string
  default     = "Internet"
}

variable "vm_size" {
  description = "Størrelsen på VM-en."
  type        = string
}

variable "ssh_public_key" {
  description = "Offentlig SSH-nøkkel for VM."
  type        = string
}

variable "webapp_sku" {
  description = "SKU for App Service-planen."
  type        = string
}

variable "state_resource_group_name" {
  description = "Ressursgruppen som inneholder Terraform-state."
  type        = string
}

variable "state_storage_account_name" {
  description = "Storage account som inneholder Terraform-state."
  type        = string
}

variable "state_container_name" {
  description = "Container for Terraform-state."
  type        = string
}
