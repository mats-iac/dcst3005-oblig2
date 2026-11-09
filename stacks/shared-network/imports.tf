data "azurerm_resource_group" "existing" {
  name = "rg-${var.kortnavn}-oblig2-${var.miljo}"
}

data "azurerm_virtual_network" "existing" {
  name                = "vnet-${var.kortnavn}-${var.miljo}"
  resource_group_name = data.azurerm_resource_group.existing.name
}

import {
  to = azurerm_resource_group.this
  id = data.azurerm_resource_group.existing.id
}

import {
  to = module.vnet.azurerm_virtual_network.this
  id = data.azurerm_virtual_network.existing.id
}
