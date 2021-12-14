terraform {
  // experiments = [module_variable_optional_attrs]
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "mel-ciscolabs-com"
    workspaces {
      name = "tf-ndo-demo-azure-vm"
    }
  }
  required_providers {
    vault = {
      source = "hashicorp/vault"
      # version = "2.18.0"
    }
    azurerm = {
      source = "hashicorp/azurerm"
      # version = "=2.46.0"
    }
    // azuread = {
    //   source = "hashicorp/azuread"
    //   # version = "1.5.1"
    // }
  }
}

# Note: TFE_PARALLELISM is not supported by Terraform Cloud Agents, but Terraform allows you to specify flags as environment variables directly via TF_CLI_ARGS.
# Use TF_CLI_ARGS_pan = -parallelism=<N>, TF_CLI_ARGS_apply = -parallelism=<N>  instead.


### Setup Azure Provider(s) ###
provider "azurerm" {
  features {}
  subscription_id = data.vault_generic_secret.azure.data["subscription_id"]
  tenant_id = data.vault_generic_secret.azure.data["tenant_id"]
  client_id = data.vault_generic_secret.azure.data["client_id"]
  client_secret = data.vault_generic_secret.azure.data["client_secret"]
}

// provider "azuread" {
//   # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider to be used
//   # version = "=1.1.0"
//   tenant_id = data.vault_generic_secret.azure.data["tenant_id"]
//   client_id = data.vault_generic_secret.azure.data["client_id"]
//   client_secret = data.vault_generic_secret.azure.data["client_secret"]
// }

module "azure" {
  source = "./modules/azure"

  tenant          = var.tenant
  azure_apps      = var.azure_apps
  instance_type   = "Standard_B1s"
  public_key      = var.public_key

  depends_on = [
    module.ndo
  ]
}
