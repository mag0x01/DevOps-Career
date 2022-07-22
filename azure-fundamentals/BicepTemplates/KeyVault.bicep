//KeyVault
@description('The resource name.')
param KeyVaultName string 
@description('The tags that will be assigned to the key vault.')
param Tags object
@description('The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault.')
param tenantID string


var AzureSchemaURL = environment().suffixes.keyvaultDns

resource KeyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: KeyVaultName
  location: 'uksouth'
  tags: Tags
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: tenantID

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

output ID string = KeyVault.id
