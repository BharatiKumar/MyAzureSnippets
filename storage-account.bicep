@description('Name of the storage account.')
param storageAccountName string

@description('Azure region for the storage account.')
param location string = resourceGroup().location

@description('SKU for the storage account.')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Standard_GZRS'
  'Standard_RAGZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param skuName string = 'Standard_LRS'

@description('Kind of the storage account.')
@allowed([
  'StorageV2'
  'BlockBlobStorage'
  'FileStorage'
  'BlobStorage'
])
param kind string = 'StorageV2'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    accessTier: kind == 'StorageV2' || kind == 'BlobStorage' ? 'Hot' : null
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
    supportsHttpsTrafficOnly: true
  }
}

output storageAccountId string = storageAccount.id
output primaryBlobEndpoint string = storageAccount.properties.primaryEndpoints.blob
