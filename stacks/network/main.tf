# Gammel nettverksstack under migrering.
# Resource Group og VNet overtas av shared-network.
# Subnettene og NSG-ressursene beholdes foreløpig her.

locals {
  tags = {
    eier  = var.kortnavn
    miljo = var.miljo
    kurs  = "dcst3005-oblig2"
  }
}

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

module "subnet" {
  source   = "../../modules/subnet"
  for_each = var.tjenester

  service             = each.key
  resource_group_name = data.azurerm_resource_group.existing.name
  location            = var.location
  vnet_name           = data.azurerm_virtual_network.existing.name
  prefix              = each.value.prefix
  delegate_web        = each.value.runtime == "webapp"
  allow_http_from     = var.allow_http_from
  tags                = local.tags
}
