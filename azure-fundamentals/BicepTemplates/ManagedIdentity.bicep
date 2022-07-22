// ----Managed Identity
@description('The resource name.')
param MIDName string 
@description('The geo-location where the resource lives.')
param MIDlocation string 
@description('Resource tags.')
param tags object

resource MID 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: MIDName
  location: MIDlocation
  tags: tags
}

output MID_ID string = MID.id
output MID_Client_ID string = MID.properties.clientId
output MID_Tenant_ID string = MID.properties.tenantId
output MID_Principal_ID string = MID.properties.principalId
