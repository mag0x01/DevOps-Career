@description('The SQL Server name.')
param serverName string  
param sqlDBName string 
param location string = resourceGroup().location
param tagsResourceType string 
param tagsScope string 
param tagsPlatform string
param tags object = {
  Scope: tagsScope
  Type: tagsResourceType
  Platform: tagsPlatform
}

param collation string = 'SQL_Latin1_General_CP1_CI_AS'
param maxSizeBytes int 
param elasticPoolId string 
param catalogCollation string='SQL_Latin1_General_CP1_CI_AS'
param zoneRedundant bool = false
param readScale string ='Disabled'
@allowed([
  'Local'
  'Zone'
  'Geo'
  'GeoZone'
])
param requestedBackupStorageRedundancy string = 'Local'
@allowed([
  'Basic'
  'Standard'
  'Premium'
  'GP_Gen5'
  'BC_Gen5'
])
@description('The Elastic Pool edition.')
param epEdition string = 'Standard'
param maintenanceConfigurationId string 

var editionToSkuMap = {
  Basic: {
    family: null
    name: 'BasicPool'
    tier: 'Basic'
  }
  Standard: {
    family: null
    name: 'ElasticPool'
    tier: 'Standard'
  }
  Premium: {
    family: null
    name: 'PremiumPool'
    tier: 'Premium'
  }
  GP_Gen5: {
    family: 'Gen5'
    name: 'GP_Gen5'
    tier: 'GeneralPurpose'
  }
  BC_Gen5: {
    family: 'Gen5'
    name: 'BC_Gen5'
    tier: 'BusinessCritical'
  }
}
var skuName = editionToSkuMap[epEdition].name
var skuTier = editionToSkuMap[epEdition].tier
var skuFamily = editionToSkuMap[epEdition].family


resource sqlDB 'Microsoft.Sql/servers/databases@2021-05-01-preview' = {
  name: '${serverName}/${sqlDBName}'
  location: location
  tags: tags
  sku: {
    capacity: 0
    name: skuName
    size: skuFamily
    tier: skuTier
  }
  properties:{
    collation: collation
    maxSizeBytes: maxSizeBytes
    elasticPoolId: elasticPoolId
    catalogCollation: catalogCollation
    zoneRedundant: zoneRedundant
    readScale: readScale
    requestedBackupStorageRedundancy: requestedBackupStorageRedundancy
    maintenanceConfigurationId: maintenanceConfigurationId
  }
}
