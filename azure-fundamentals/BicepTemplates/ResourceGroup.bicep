// ----- Create Resource Group -----
@description('The resource name')
param rgName string
@description('The location of the resource group. It cannot be changed after the resource group has been created. It must be one of the supported Azure locations.')
param rgLocation string
@description('Owner of the resources.')
param tagsResourceOwner string
@description('The reason why the resource has been created.')
param tagsEnvironment string
@description('Values/properties that help to categorize/organize resources.')
param tags object = {
  Owner: tagsResourceOwner
  Environment: tagsEnvironment
}
targetScope = 'subscription'

resource rg_resource 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: rgName
  location: rgLocation
  properties: {}
  tags: tags
}
