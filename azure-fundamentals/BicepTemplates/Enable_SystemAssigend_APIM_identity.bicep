//A system assigned managed identity is restricted to one per resource and is tied to the lifecycle of this resource.
// You can grant permissions to the managed identity by using Azure role-based access control (Azure RBAC). 
//The managed identity is authenticated with Azure AD, so you don’t have to store any credentials in code.
//Enable System assigned identities on APIM and add access policies to this one.
// To APIM deployment:
//param identity string = 'SystemAssigned'
@description('KeyVault name')
param KeyVaultName string 
@description('APIM name')
param apimName string

resource KEYVAUKT 'Microsoft.KeyVault/vaults@2021-04-01-preview' existing = {
  name: KeyVaultName
}
resource API 'Microsoft.ApiManagement/service@2020-12-01' existing = {
  name: apimName
}
var IdentityID = '${API.id}/providers/Microsoft.ManagedIdentity/Identities/default'

resource POL 'Microsoft.KeyVault/vaults/accessPolicies@2019-09-01' = {
  name: '${KeyVaultName}/add'
  dependsOn: [
    KEYVAUKT
    API
  ]
  properties:{
    accessPolicies: [
      {
        //applicationId: reference(IdentityID, '2018-11-30').clientId
        tenantId: reference(IdentityID, '2018-11-30').tenantId
        objectId: reference(IdentityID, '2018-11-30').principalId  
        permissions: {
          keys: [
            'get'
            'list'
          ]
          secrets: [
            'get'
            'list'
          ]
          certificates: [
            'get'
            'list'
          ]
        }
      }
    ]
  }
}
output idi string = IdentityID
output tenantID string = reference(IdentityID, '2018-11-30').tenantId
output applicationID string = reference(IdentityID, '2018-11-30').clientId
output objectID string = reference(IdentityID, '2018-11-30').principalId
