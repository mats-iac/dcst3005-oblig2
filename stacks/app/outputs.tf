
# Les eksisterende Azure-ressurser under migreringen.
# Den nye service-stacken skal overta Terraform-eierskapet.

data "azurerm_public_ip" "existing" {
  for_each = {
    for navn, runtime in var.tjenester :
    navn => runtime if runtime == "vm"
  }

  name                = "pip-${each.key}"
  resource_group_name = local.network.resource_group_name
}

data "azurerm_linux_web_app" "existing" {
  for_each = {
    for navn, runtime in var.tjenester :
    navn => runtime if runtime == "webapp"
  }

  name                = "app-${var.kortnavn}-${each.key}-${var.miljo}"
  resource_group_name = local.network.resource_group_name
}

output "vm_public_ips" {
  description = "Offentlig IP per VM-tjeneste."
  value = {
    for navn, pip in data.azurerm_public_ip.existing :
    navn => pip.ip_address
  }
}

output "webapp_hostnames" {
  description = "Vertsnavn per Web App-tjeneste."
  value = {
    for navn, app in data.azurerm_linux_web_app.existing :
    navn => app.default_hostname
  }
}
