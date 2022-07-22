//Storage Account
@description('The resource name.')
param storageAccountName string 
@description('The resource location.')
param storageAccountLocation string
@description('The SKU of the storage account.')
param accountType string 
@description('Indicates the type of storage account.')
param Kind string
@description('Required for storage accounts where kind = BlobStorage. The access tier used for billing. Cool/Hot')
param accessTier string 
param minimumTLSVersion string = 'TLS1_2'
param supportsHttpsTrafficOnly bool = false
param allowBlobPublicAccess bool = false
param allowSharedKeyAccess bool = true
param isContainerRestoreEnabled bool = false
param isBlobSoftDeleteEnabled bool = false
param blobSoftDeleteRetentionDays int = 7
param isContainerSoftDeleteEnabled bool = false
param containerSoftDeleteRetentionDays int = 7
param changeFeed bool = false
param isVersioningEnabled bool = false
param isShareSoftDeleteEnabled bool = false
param shareSoftDeleteRetentionDays int = 7
@description('Values/properties that help to categorize/organize resources.')
param Tags object


resource SA 'Microsoft.Storage/storageAccounts@2019-06-01' =  {
  name: storageAccountName
  location: storageAccountLocation
  sku: {
    name: accountType
  }
  tags: Tags
  kind: Kind
  properties: {
    accessTier: accessTier
    minimumTlsVersion: minimumTLSVersion
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
    allowBlobPublicAccess: allowBlobPublicAccess
    allowSharedKeyAccess: allowSharedKeyAccess
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}
resource BLOB 'Microsoft.Storage/storageAccounts/blobServices@2021-04-01' = {
  name: '${storageAccountName}/default'
  properties:{
    restorePolicy: {
      enabled: isContainerRestoreEnabled
    }
    deleteRetentionPolicy: {
      enabled: isBlobSoftDeleteEnabled
      days: blobSoftDeleteRetentionDays
    }
    containerDeleteRetentionPolicy: {
      enabled: isContainerSoftDeleteEnabled
      days:containerSoftDeleteRetentionDays
    }
    changeFeed:{
      enabled:changeFeed
    }
    isVersioningEnabled: isVersioningEnabled
  }
  dependsOn: [
    SA
  ]
}

resource FILESERVICE 'Microsoft.Storage/storageAccounts/fileServices@2021-04-01' = {
  name: '${storageAccountName}/default'
  properties:{
    shareDeleteRetentionPolicy: {
      enabled: isShareSoftDeleteEnabled
      days:shareSoftDeleteRetentionDays
    }
  }
  dependsOn: [
    SA
  ]
}

resource QUEUESERVICE 'Microsoft.Storage/storageAccounts/queueServices@2021-04-01' = {
  name: '${storageAccountName}/default'
  properties:{
    cors: {
      corsRules: []
    }
  }
  dependsOn: [
    SA
  ]
}

resource TABLESERVICE 'Microsoft.Storage/storageAccounts/tableServices@2021-04-01' = {
  name: '${storageAccountName}/default'
  properties:{
    cors: {
      corsRules: []
    }
  }
  dependsOn: [
    SA
  ]
}
