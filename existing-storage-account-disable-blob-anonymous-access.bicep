@description('Name of the existing storage account.')
param storageAccountName string

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: storageAccountName
}

resource storageAccountUpdate 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: existingStorageAccount.name
  location: existingStorageAccount.location
  sku: {
    name: existingStorageAccount.sku.name
  }
  kind: existingStorageAccount.kind
  properties: {
    accessTier: existingStorageAccount.kind == 'StorageV2' || existingStorageAccount.kind == 'BlobStorage'
      ? any(existingStorageAccount.properties.accessTier)
      : null
    allowBlobPublicAccess: false
    minimumTlsVersion: any(existingStorageAccount.properties.minimumTlsVersion)
    supportsHttpsTrafficOnly: any(existingStorageAccount.properties.supportsHttpsTrafficOnly)
  }
}

output storageAccountId string = storageAccountUpdate.id
