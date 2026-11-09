# Gammel nettverksstack under migrering.
# Resource Group og VNet overtas av shared-network.
# Subnettene og NSG-ressursene beholdes foreløpig her.


# Slutter å administrere ressursgruppen gjennom denne staten,
# men behold den fysiske ressursen i Azure.
removed {
  from = azurerm_resource_group.this

  lifecycle {
    destroy = false
  }
}

# Slutter å administrere VNet-modulen gjennom denne staten,
# uten å slette VNet-et i Azure.
removed {
  from = module.vnet

  lifecycle {
    destroy = false
  }
}

# Les de eksisterende ressursene fra Azure.
data "azurerm_resource_group" "existing" {
  name = "rg-${var.kortnavn}-oblig2-${var.miljo}"
}

data "azurerm_virtual_network" "existing" {
  name                = "vnet-${var.kortnavn}-${var.miljo}"
  resource_group_name = data.azurerm_resource_group.existing.name
}

removed {
  from = module.subnet

  lifecycle {
    destroy = false
  }
}

# Les eksisterende subnett slik at network fortsatt kan
# eksportere subnett-ID-er under migreringen.
data "azurerm_subnet" "existing" {
  for_each = var.tjenester

  name                 = "snet-${each.key}"
  virtual_network_name = data.azurerm_virtual_network.existing.name
  resource_group_name  = data.azurerm_resource_group.existing.name
}
