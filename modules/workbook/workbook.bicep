//=============================================================================
// Azure Workbook
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

@description('The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('The user-defined name (display name) of the workbook. If an environment is specified, it will be appended to the display name to create a unique display name for the workbook.')
param displayName string

@description('The environment for this workbook instance. This is used to create a unique display name for the workbook. For example: "dev", "test" or "prod".')
param environment string

@description('The name of the App Insights instance that will be used to set as the source resource.')
param appInsightsName string?

@description('The name of the Log Analytics workspace that will be used to set as the source resource.')
param logAnalyticsWorkspaceName string?

@description('Configuration of this particular workbook. Configuration data is a string containing valid JSON.')
param serializedData string

@description('A dictionary of placeholder values to replace in the serializedData. The keys are the placeholder names, and the values are the replacement values.')
param placeholders { *: string }?

@description('Workbook category, as defined by the user at creation time. Default: workbook.')
param category string = 'workbook'

@description('Workbook schema version format, like \'Notebook/1.0\', which should match the workbook in serializedData. Default: Notebook/1.0')
param version string = 'Notebook/1.0'

//=============================================================================
// Variables
//=============================================================================

var workbookDisplayName = environment == '' ? displayName : '${displayName} (${environment})'
var workbookContent = placeholders == null ? serializedData : replacePlaceholders(serializedData, items(placeholders!))
var workbookSourceId = appInsights.?id ?? logAnalyticsWorkspace.?id ?? 'azure monitor'

//=============================================================================
// Functions
//=============================================================================

func replacePlaceholders(originalString string, placeholders array) string =>
  reduce(
    placeholders, 
    originalString, // this is the first 'current'
    (current, next) => replacePlaceholder(current, next.key, next.value)
  )

func replacePlaceholder(originalString string, placeholder string, value string) string =>
  replace(originalString, '##${placeholder}##', value)


//=============================================================================
// Existing resources
//=============================================================================

resource appInsights 'Microsoft.Insights/components@2020-02-02' existing = if (appInsightsName != null) {
  name: appInsightsName!
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2025-07-01' existing = if (logAnalyticsWorkspaceName != null) {
  name: logAnalyticsWorkspaceName!
}

//=============================================================================
// Resources
//=============================================================================

resource workbook 'Microsoft.Insights/workbooks@2023-06-01' = {
  name: guid(resourceGroup().id, displayName, environment)
  location: location
  kind: 'shared' // Only valid value for kind is 'shared'
  properties: {
    displayName: workbookDisplayName
    category: category
    serializedData: workbookContent
    sourceId: workbookSourceId
    version: version
  }
}
