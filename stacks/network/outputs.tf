
output "resource_group_name" {
  description = "Ressursgruppen som nå eies av shared-network."
  value       = data.azurerm_resource_group.existing.name
}

output "location" {
  description = "Azure-regionen."
  value       = data.azurerm_resource_group.existing.location
}

output "vnet_name" {
  description = "VNet som nå eies av shared-network."
  value       = data.azurerm_virtual_network.existing.name
}


output "subnet_ids" {
  description = "Subnett-ID per tjeneste, hentet fra eksisterende Azure-ressurser."
  value = {
    for navn, subnett in data.azurerm_subnet.existing :
    navn => subnett.id
  }
}

