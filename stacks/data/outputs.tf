
# Behold eksisterende outputs under migreringen.
# Ressursene administreres videre av service-stacken.

data "azurerm_storage_account" "existing" {
  for_each = toset(var.tjenester)

  name                = "st${var.kortnavn}${each.value}${var.miljo}"
  resource_group_name = local.network.resource_group_name
}

data "azurerm_key_vault" "existing" {
  for_each = toset(var.tjenester)

  name                = "kv-${var.kortnavn}-${each.value}-${var.miljo}"
  resource_group_name = local.network.resource_group_name
}

output "storage_account_names" {
  description = "Storage account per tjeneste."
  value       = { for navn, s in data.azurerm_storage_account.existing : navn => s.name }
}

output "key_vault_names" {
  description = "Key Vault per tjeneste."
  value       = { for navn, k in data.azurerm_key_vault.existing : navn => k.name }
}
