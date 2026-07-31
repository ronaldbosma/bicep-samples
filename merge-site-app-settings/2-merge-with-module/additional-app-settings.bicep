//=============================================================================
// Merge With Module Scenario - Deploy Additional App Settings
//=============================================================================

//=============================================================================
// Parameters
//=============================================================================

param siteName string = 'func-scenario2-${uniqueString(resourceGroup().id)}'

//=============================================================================
// Variables
//=============================================================================

var additionalAppSettings resourceInput<'Microsoft.Web/sites/config@2025-03-01'>.properties = {
  APP_SPECIFIC_SETTING_1: 'SomeValue'
  APP_SPECIFIC_SETTING_2: 'AnotherValue'
}
//=============================================================================
// Existing Resources
//=============================================================================

resource site 'Microsoft.Web/sites@2025-03-01' existing = {
  name: siteName
}

//=============================================================================
// Resources
//=============================================================================

module mergeAppSettings 'merge-app-settings.bicep' = {
  params: {
    siteName: siteName
    currentAppSettings: list('${site.id}/config/appsettings', site.apiVersion).properties
    newAppSettings: additionalAppSettings
  }
}
