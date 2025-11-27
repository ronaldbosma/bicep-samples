//=============================================================================
// Use this.existingResource() Scenario - Deploy Site
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

param location string = resourceGroup().location
param storageAccountName string = 'st${uniqueString(resourceGroup().id)}'
param appServicePlanName string = 'asp-${uniqueString(resourceGroup().id)}'
param siteName string = 'func-${uniqueString(resourceGroup().id)}'

//=============================================================================
// Variables
//=============================================================================

var storageAccountConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};EndpointSuffix=${environment().suffixes.storage};AccountKey=${storageAccount.listKeys().keys[0].value}'

var appSettings object = {
    AzureWebJobsStorage: storageAccountConnectionString
    FUNCTIONS_EXTENSION_VERSION: '~4'
    FUNCTIONS_WORKER_RUNTIME: 'dotnet-isolated'
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING: storageAccountConnectionString
    WEBSITE_CONTENTSHARE: toLower(siteName)
    WEBSITE_USE_PLACEHOLDER_DOTNETISOLATED: '1'
}

//=============================================================================
// Resources
//=============================================================================

resource storageAccount 'Microsoft.Storage/storageAccounts@2024-01-01' = {
  name: storageAccountName
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
  properties: {
    supportsHttpsTrafficOnly: true
    defaultToOAuthAuthentication: true
  }
}

resource hostingPlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  kind: 'functionapp'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

resource site 'Microsoft.Web/sites@2024-04-01' = {
  name: siteName
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: hostingPlan.id
    siteConfig: {
      // NOTE: the app settings will be set separately
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
      netFrameworkVersion: 'v9.0'
    }
    httpsOnly: true
  }

  dependsOn: [
    storageAccount
  ]
}

resource siteAppSettings 'Microsoft.Web/sites/config@2024-04-01' = {
  parent: site
  name: 'appsettings'
  properties: union(appSettings, this.existingResource().?properties)
}
