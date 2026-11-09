
# Datalaget gir fra seg eierskapet til service-stacken.
# Eksisterende Azure-ressurser skal ikke slettes.

data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = {
    resource_group_name  = var.state_resource_group_name
    storage_account_name = var.state_storage_account_name
    container_name       = var.state_container_name
    key                  = "oblig2/${var.miljo}/network.tfstate"
    use_azuread_auth     = true
  }
}

locals {
  network = data.terraform_remote_state.network.outputs
}

removed {
  from = module.storage

  lifecycle {
    destroy = false
  }
}

removed {
  from = module.keyvault

  lifecycle {
    destroy = false
  }
}
