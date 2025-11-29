# Scenario 2: Merge App Settings Using Module

In this scenario, we demonstrate the use of a module to merge existing app settings with new app settings when deploying to an existing App Service.

To execute this scenario, run the following command where `<your-resource-group>` is the name of your resource group:

```cmd
. .\deploy.ps1 -ResourceGroupName "<your-resource-group>"
```

It will:
- first deploy a storage account and app service using [site.bicep](./site.bicep) with some default app settings
- ask for confirmation to proceed _(before you do, check the app settings in the Azure portal)_
- then it will deploy [additional-app-settings.bicep](./1-no-merge/additional-app-settings.bicep) to add more app settings

The second deployment will merge the app settings set by the first deployment, resulting in both the existing and new app settings being present.
If you would run the deployment again, it will keep merging the app settings without overwriting existing ones.

A possible downside of this approach is that app app settings are not removed if they are no longer present in the new app settings.

> The sample uses a Function App, but the same applies to all sites.

Note that we're using a separate module to merge the app settings, because the following doesn't work:

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
