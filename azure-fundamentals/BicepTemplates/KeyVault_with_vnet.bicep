//KeyVault
@description('The resource name.')
param KeyVaultName string 
@description('The tags that will be assigned to the key vault.')
param Tags object
@description('The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.')
param tenantID string
@description('Subnet name. Array e.g. [{"name":"subnets/01-subnet"}]')
param subnetsNames array
@description('The list of IP address rules. Array E.g.[{"rule":"194.126.146.46/32"}]')
param IPRULES array 
param VnetID string



var subnets = [ for subnet in subnetsNames: {
  id: '${VnetID}/${subnet.name}'
  ignoreMissingVnetServiceEndpoint: false
}]

var ipreules = [ for ip in IPRULES: {
  value: '${ip.rule}'
}]

var AzureSchemaURL = environment().suffixes.keyvaultDns

resource KeyVault 'Microsoft.KeyVault/vaults@2021-04-01-preview' = {
  name: KeyVaultName
  location: 'uksouth'
  tags: Tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantID
    networkAcls: {
      bypass: 'AzureServices'
      defaultAction: 'Deny'
      ipRules: ipreules
      virtualNetworkRules: subnets
    }
    accessPolicies: []
    enabledForDeployment: true
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: true
    enableSoftDelete: true
    enableRbacAuthorization: false
    vaultUri: 'https://${KeyVaultName}${AzureSchemaURL}/'
    provisioningState: 'Succeeded'
  }
}


output KEYVAULT_NAME string = KeyVault.name
output KEYVAUKT_ID string = KeyVault.id
