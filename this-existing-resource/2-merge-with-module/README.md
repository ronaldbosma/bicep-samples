# Scenario: Merge App Settings Using Module

We're using a separate module to merge the app settings, because the following doesn't work:

```bicep
resource siteAppSettings 'Microsoft.Web/sites/config@2024-04-01' = {
  parent: site
  name: 'appsettings'
  properties: union(list('${site.id}/config/appsettings', site.apiVersion).properties, appSettings)
}
```

It results in the following error:

```json
{
    "code": "InvalidTemplate",
    "message": "Deployment template validation failed: 'Circular dependency detected on resource: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test-this-existing-resource/providers/Microsoft.Web/sites/func-ks422aojbieza/config/appsettings'. Please see https://aka.ms/arm-syntax-resources for usage details.'.",
    "additionalInfo": [
        {
            "type": "TemplateViolation",
            "info": {
                "lineNumber": 0,
                "linePosition": 0,
                "path": ""
            }
        }
    ]
}
```
