//You can programmatically manage your API Management service through Azure Resource Manager (ARM).
// Enable direct management REST API to use SAS token authentication and bypass ARM's limitations.

@description('The resource APIM name.')
param apimName string 

resource API 'Microsoft.ApiManagement/service@2020-12-01' existing = {
  name: apimName
}
resource REST 'Microsoft.ApiManagement/service/tenant@2021-01-01-preview' = {
  name: '${API.name}/access'
  dependsOn: [
    API
  ]
  properties:{
    enabled: true
  }
}
