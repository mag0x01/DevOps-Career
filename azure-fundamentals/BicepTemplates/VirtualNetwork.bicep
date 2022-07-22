//Virtual Network
@description('Resource location.')
param vnetLocation string 
param extendedLocation object = {}
@description('The resource name.')
param virtualNetworkName string 
@description('AddressSpace contains an array of IP address ranges that can be used by subnets of the virtual network.')
param addressSpaces string
param ddosProtectionPlanEnabled bool = false
@description('Resource tags.')
param Tags object
@description('Sbubnet definition. Eg. [{"name":"subnetName","subnetPrefix":"10.4.1.0/24","serviceEndpoints":{"service":"Microsoft.KeyVault"}}] ')
param subnetsDefinitions array

resource virtualNetworkName_resource 'Microsoft.Network/virtualNetworks@2021-02-01' =  {
  name: virtualNetworkName
  location: vnetLocation
  extendedLocation: (empty(extendedLocation) ? json('null') : extendedLocation)
  tags: Tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressSpaces
      ]
    }
    subnets: [for subnet in subnetsDefinitions: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
        privateLinkServiceNetworkPolicies: 'Enabled'
        serviceEndpoints: subnet.serviceEndpoints
      }
    }]
    enableDdosProtection: ddosProtectionPlanEnabled
  }
  dependsOn: []
}
output VNET_ID string = virtualNetworkName_resource.id
