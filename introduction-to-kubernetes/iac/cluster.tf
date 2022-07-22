resource "azurerm_kubernetes_cluster" "cluster" {
  name                = "${local.env}-aks"
  location            = local.config.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = local.env

  default_node_pool {
    name       = "workers"
    node_count = local.config.cluster_pool_size
    vm_size    = local.config.instance_type
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.cluster.kube_config_raw

  sensitive = true
}
