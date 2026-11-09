
output "subnet_id" {
  description = "ID-en til tjenestens subnett."
  value       = module.subnet.subnet_id
}

output "nsg_id" {
  description = "ID-en til tjenestens Network Security Group."
  value       = module.subnet.nsg_id
}

output "storage_account_name" {
  description = "Navnet på tjenestens Storage account."
  value       = module.storage.name
}

output "key_vault_name" {
  description = "Navnet på tjenestens Key Vault."
  value       = module.keyvault.name
}

output "vm_public_ip" {
  description = "Offentlig IP for VM-tjenester, ellers null."
  value       = var.runtime == "vm" ? module.vm[0].public_ip : null
}

output "webapp_hostname" {
  description = "Vertsnavn for Web App-tjenester, ellers null."
  value       = var.runtime == "webapp" ? module.webapp[0].hostname : null
}
