# Azure Workbook module

Sample usage:

```bicep
@description('The geo-location where the resource lives.')
param location string = resourceGroup().location

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: 'appi-aisquick-sdc-taqld'
}

resource apiManagementService 'Microsoft.ApiManagement/service@2025-03-01-preview' existing = {
  name: 'apim-aisquick-sdc-taqld'
}

module workbook 'workbook.bicep' = {
  params: {
    location: location
    displayName: 'Sample Workbook'
    environment: 'test'
    serializedData: loadTextContent('./sample.workbook')
    placeholders: {
      AzureSubscriptionId: subscription().subscriptionId
      ApplicationInsightsId: appInsights.id
      ApiManagementId: apiManagementService.id
    }
  }
}
```

The `sample.workbook` file contains the workbook JSON. The JSON can have placeholders like `##AzureSubscriptionId##`, that will be replaced with the specified placeholder value.