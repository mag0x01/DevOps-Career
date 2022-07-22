# Init the project the from backend.tf
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.90.0"
    }
  }

}

provider "azurerm" {
  features {}
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.env}-kubernetes"
  location = local.config.location
}

# Configuration for resources

locals {
	env = "${terraform.workspace}-${random_string.suffix.result}"
	config = {
		instance_type = "Standard_D2_v2" # https://docs.microsoft.com/en-us/azure/virtual-machines/dv2-dsv2-series
		cluster_pool_size = 1 # this refers to the worker nodes
		location = "northeurope"
	}

	tags = {
		"environment" = local.env
		"project"			= "RSDevOps"
	}
}
