
# Migrering av eksisterende nettverksressurser.
# Ingen Azure-ressurser skal opprettes eller slettes.

data "azurerm_subnet" "existing" {
  name                 = "snet-${var.service}"
  virtual_network_name = local.network.vnet_name
  resource_group_name  = local.network.resource_group_name
}

data "azurerm_network_security_group" "existing" {
  name                = "nsg-${var.service}"
  resource_group_name = local.network.resource_group_name
}

# Eksisterende subnett
import {
  to = module.subnet.azurerm_subnet.this
  id = data.azurerm_subnet.existing.id
}

# Eksisterende Network Security Group
import {
  to = module.subnet.azurerm_network_security_group.this
  id = data.azurerm_network_security_group.existing.id
}

# Eksisterende HTTP-regel
import {
  to = module.subnet.azurerm_network_security_rule.http
  id = "${data.azurerm_network_security_group.existing.id}/securityRules/allow-http"
}

# Eksisterende kobling mellom subnett og NSG
import {
  to = module.subnet.azurerm_subnet_network_security_group_association.this
  id = data.azurerm_subnet.existing.id
}


# Eksisterende Storage account
data "azurerm_storage_account" "existing" {
  name                = "st${var.kortnavn}${var.service}${var.miljo}"
  resource_group_name = local.network.resource_group_name
}

import {
  to = module.storage.azurerm_storage_account.this
  id = data.azurerm_storage_account.existing.id
}

# Eksisterende Key Vault
data "azurerm_key_vault" "existing" {
  name                = "kv-${var.kortnavn}-${var.service}-${var.miljo}"
  resource_group_name = local.network.resource_group_name
}

import {
  to = module.keyvault.azurerm_key_vault.this
  id = data.azurerm_key_vault.existing.id
}


# VM-ressurser: importeres bare for tjenester med runtime = "vm".

data "azurerm_public_ip" "existing" {
  for_each = var.runtime == "vm" ? toset([var.service]) : toset([])

  name                = "pip-${each.key}"
  resource_group_name = local.network.resource_group_name
}

data "azurerm_network_interface" "existing" {
  for_each = var.runtime == "vm" ? toset([var.service]) : toset([])

  name                = "nic-${each.key}"
  resource_group_name = local.network.resource_group_name
}

data "azurerm_virtual_machine" "existing" {
  for_each = var.runtime == "vm" ? toset([var.service]) : toset([])

  name                = "vm-${each.key}"
  resource_group_name = local.network.resource_group_name
}

import {
  for_each = var.runtime == "vm" ? toset([var.service]) : toset([])

  to = module.vm[0].azurerm_public_ip.this
  id = data.azurerm_public_ip.existing[each.key].id
}

import {
  for_each = var.runtime == "vm" ? toset([var.service]) : toset([])

  to = module.vm[0].azurerm_network_interface.this
  id = data.azurerm_network_interface.existing[each.key].id
}

import {
  for_each = var.runtime == "vm" ? toset([var.service]) : toset([])

  to = module.vm[0].azurerm_linux_virtual_machine.this
  id = data.azurerm_virtual_machine.existing[each.key].id
}


# Web App-ressurser: importeres bare for runtime = "webapp".

data "azurerm_service_plan" "existing" {
  for_each = var.runtime == "webapp" ? toset([var.service]) : toset([])

  name                = "asp-${each.key}"
  resource_group_name = local.network.resource_group_name
}

data "azurerm_linux_web_app" "existing" {
  for_each = var.runtime == "webapp" ? toset([var.service]) : toset([])

  name                = "app-${var.kortnavn}-${each.key}-${var.miljo}"
  resource_group_name = local.network.resource_group_name
}

import {
  for_each = var.runtime == "webapp" ? toset([var.service]) : toset([])

  to = module.webapp[0].azurerm_service_plan.this
  id = data.azurerm_service_plan.existing[each.key].id
}

import {
  for_each = var.runtime == "webapp" ? toset([var.service]) : toset([])

  to = module.webapp[0].azurerm_linux_web_app.this
  id = data.azurerm_linux_web_app.existing[each.key].id
}
