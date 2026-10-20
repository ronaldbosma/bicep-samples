# Azure Workbook module

Deploys an Azure Monitor workbook with configurable metadata and JSON content. Optional placeholders in the workbook content are replaced with supplied values before deployment.

## Usage Examples

```bicep
@description('The geo-location where the resource lives.')
param location string = resourceGroup().location

param tags { *: string } = {
  environment: dev
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: 'appi-aisquick-sdc-taqld'
}

resource apiManagementService 'Microsoft.ApiManagement/service@2025-09-01-preview' existing = {
  name: 'apim-aisquick-sdc-taqld'
}

module workbook 'workbook.bicep' = {
  params: {
    environmentName: 'dev'
    location: location
    tags: tags
    displayName: 'Sample Workbook'
    serializedData: string(loadJsonContent('./sample.workbook'))
    placeholders: {
      AzureSubscriptionId: subscription().subscriptionId
      ApplicationInsightsId: appInsights.id
      ApiManagementId: apiManagementService.id
    }
  }
}
```

The `sample.workbook` file should contain the workbook JSON. It can include placeholders such as `##AzureSubscriptionId##`, which are replaced with the corresponding values in `placeholders`.

## Module format

To deploy a workbook using the [workbook module](./workbook.bicep), add the following Bicep to your template.

```bicep
module workbook 'workbook.bicep' = {
  params: {
    environmentName: 'string'
    location: 'string'
    tags: {
      {customized property}: 'string'
    }
    displayName: 'string'
    serializedData: 'string'
    placeholders: {
      {customized property}: 'string'
    }
    sourceId: 'string'
    category: 'string'
    version: 'string'
  }
}
```

## Parameter Values

| Name | Description | Value |
|---|---|---|
| `environmentName` | Name of the environment to deploy to. Appended to the workbook display name when not empty. | `string (required)` |
| `location` | Location to use for the resource. | `string (required)` |
| `tags` | Tags to associate with the workbook. | `resourceInput<'Microsoft.Insights/workbooks@2023-06-01'>.tags` |
| `displayName` | User-defined workbook display name. | `string (required)` |
| `serializedData` | Workbook configuration as a string containing valid JSON. Placeholders should follow the format `##<name>##`. | `string (required)` |
| `placeholders` | Map of placeholder names to replacement values for `serializedData`. | `{ *: string }?` |
| `sourceId` | Resource ID of the source resource, such as an Application Insights instance or Log Analytics workspace. | `string (default: 'azure monitor')` |
| `category` | Workbook category. | `string (default: 'workbook')` |
| `version` | Workbook schema version, which should match the workbook content. | `string (default: 'Notebook/1.0')` |