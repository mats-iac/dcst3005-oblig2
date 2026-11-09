# Applaget for ALLE tjenestene: en VM eller en web app per tjeneste, koblet til
# subnettet som network-stacken har laget for den.

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


# Flytt VM, NIC og Public IP til service-stacken.
# Behold alle fysiske ressurser i Azure.
removed {
  from = module.vm

  lifecycle {
    destroy = false
  }
}

# Flytt App Service-plan og Web App til service-stacken.
# Behold alle fysiske ressurser i Azure.
removed {
  from = module.webapp

  lifecycle {
    destroy = false
  }
}
