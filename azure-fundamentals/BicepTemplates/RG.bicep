param rgName string
param rgLocation string
param tagsResourceType string
param tagsScope string
param tagsPlatform string
param tags object = {
  Scope: tagsScope
  Type: tagsResourceType
  Platform: tagsPlatform
}
targetScope = 'subscription'

resource rg_resource 'Microsoft.Resources/resourceGroups@2021-01-01' = {
  name: rgName
  location: rgLocation
  properties: {}
  tags: tags
}
