terraform {
  required_version = ">= 1.0.7"

  required_providers {
    tls   = ">= 3.4"
    local = ">= 2.2.3"
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.15.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}