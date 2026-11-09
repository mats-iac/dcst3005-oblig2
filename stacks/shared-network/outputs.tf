
output "resource_group_name" {
  description = "Navnet på den delte ressursgruppen."
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "Azure-regionen."
  value       = azurerm_resource_group.this.location
}

output "vnet_name" {
  description = "Navnet på det delte VNet-et."
  value       = module.vnet.name
}

output "vnet_id" {
  description = "Ressurs-ID-en til det delte VNet-et."
  value       = module.vnet.id
}
