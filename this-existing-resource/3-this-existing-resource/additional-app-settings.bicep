//=============================================================================
// Use this.existingResource() Scenario - Deploy Additional App Settings
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

param siteName string = 'func-${uniqueString(resourceGroup().id)}'

//=============================================================================
// Variables
//=============================================================================

var additionalAppSettings object = {
  APP_SPECIFIC_SETTING_1: 'SomeValue'
  APP_SPECIFIC_SETTING_2: 'AnotherValue'
}
//=============================================================================
// Existing Resources
//=============================================================================

resource site 'Microsoft.Web/sites@2024-04-01' existing = {
  name: siteName
}

//=============================================================================
// Resources
//=============================================================================

resource siteAppSettings 'Microsoft.Web/sites/config@2024-04-01' = {
  parent: site
  name: 'appsettings'
  properties: union(additionalAppSettings, this.existingResource().?properties)
}
