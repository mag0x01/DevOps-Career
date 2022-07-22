param elasticPoolName string
param tagsResourceType string
param tagsScope string
param tagsPlatform string
param elasticPoolTags object = {
  Scope: tagsScope
  Type: tagsResourceType
  Platform: tagsPlatform
}
param serverName string
param serverLocation string = resourceGroup().location
param skuName string
param tier string
param poolLimit int
param poolSize int
param perDatabasePerformanceMin int
param perDatabasePerformanceMax int
param zoneRedundant bool
param licenseType string
param maintenanceConfigurationId string

resource elasticPool 'Microsoft.Sql/servers/elasticpools@2020-08-01-preview' = {
  name: '${serverName}/${elasticPoolName}'
  tags: elasticPoolTags
  location: serverLocation
  sku: {
    name: skuName
    tier: tier
    capacity: poolLimit
  }
  properties: {
    perDatabaseSettings: {
      minCapacity: perDatabasePerformanceMin
      maxCapacity: perDatabasePerformanceMax
    }
    maxSizeBytes: poolSize
    zoneRedundant: zoneRedundant
    licenseType: licenseType
    maintenanceConfigurationId: maintenanceConfigurationId
  }
}
