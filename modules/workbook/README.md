# Azure Workbook module

Deploys an Azure Monitor workbook with configurable metadata and JSON content. Optional placeholders in the workbook content are replaced with supplied values before deployment. If any placeholders remain unresolved after replacement, deployment fails with an error similar to:

```text
Workbook "Sample Workbook (dev)" still contains unresolved placeholders.
```

## Usage Examples

```bicep
param environmentName string = 'dev'
param location string = resourceGroup().location

param tags { *: string } = {
  environment: environmentName
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = {
  name: 'appi-aisquick-sdc-taqld'
}

resource apiManagementService 'Microsoft.ApiManagement/service@2025-09-01-preview' existing = {
  name: 'apim-aisquick-sdc-taqld'
}

module workbook 'workbook.bicep' = {
  params: {
    environmentName: environmentName
    location: location
    tags: tags
    displayName: 'Sample Workbook'
    serializedData: string(loadJsonContent('./sample.workbook'))
    placeholders: {
      AzureSubscriptionId: subscription().subscriptionId
      ApplicationInsightsId: appInsights.id
      ApiManagementId: apiManagementService.id
    }
    sourceId: appInsights.id
  }
}
```

Because the environment name is `dev`, the workbook shows up as `Sample Workbook (dev)`.

### Sample workbook with placeholder

The `sample.workbook` file is the workbook JSON that you can export from the Advanced Editor in the Azure portal. In that file, replace the hard-coded values with placeholders. A simplified example looks like this:

```json
{
  "version": "Notebook/1.0",
  "items": [
    {
      "type": 3,
      "content": {
        "version": "KqlItem/1.0",
        "query": "requests | summarize count() by name",
        "queryType": 0,
        "resourceType": "microsoft.insights/components",
        "crossComponentResources": [ "##ApplicationInsightsId##" ]
      },
      "name": "RequestsPerOperation"
    }
  ]
}
```

When the module is deployed, `##ApplicationInsightsId##` is replaced with the resource ID of the Application Insights instance. The same goes for `##AzureSubscriptionId##` and `##ApiManagementId##`.

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
| `environmentName` | Name of the environment to deploy to. Appended to the workbook display name when not empty. | `string (default: '')` |
| `location` | Location to use for the resource. | `string (required)` |
| `tags` | Tags to associate with the workbook. | `resourceInput<'Microsoft.Insights/workbooks@2023-06-01'>.tags` |
| `displayName` | User-defined workbook display name. Appended by environment name if specified. <br/><br/> If the display name is 'Sample Workbook' and the environment name 'dev', the display name of the workbook will be 'Sample Workbook (dev)' | `string (required)` |
| `serializedData` | Workbook configuration as a string containing valid JSON. Placeholders should follow the format `##<name>##`. | `string (required)` |
| `placeholders` | Map of placeholder names to replacement values for `serializedData`. | `{ *: string }?` |
| `sourceId` | Resource ID of the source resource, such as an Application Insights instance or Log Analytics workspace. | `string (default: 'azure monitor')` |
| `category` | Workbook category. | `string (default: 'workbook')` |
| `version` | Workbook schema version, which should match the workbook content. | `string (default: 'Notebook/1.0')` |

## Links

- [Microsoft.Insights/workbooks Bicep resource](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/workbooks?pivots=deployment-language-bicep)
- [Deploy Azure Workbooks with a Reusable Bicep Module](https://ronaldbosma.github.io/blog/2026/10/27/deploy-azure-workbooks-with-a-reusable-bicep-module/)
