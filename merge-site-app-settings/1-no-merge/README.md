# Scenario 1: No Merge of App Settings

In this scenario, we demonstrate what happens when you deploy additional app settings to an existing App Service without merging them with the existing app settings.
This will result in the new app settings overwriting the existing ones.

To execute this scenario, run the following command where `<your-resource-group>` is the name of your resource group:

```cmd
. .\deploy.ps1 -ResourceGroupName "<your-resource-group>"
```

It will:
- first deploy a storage account and app service using [site.bicep](./site.bicep) with some default app settings
- ask for confirmation to proceed _(before you do, check the app settings in the Azure portal)_
- then it will deploy [additional-app-settings.bicep](./1-no-merge/additional-app-settings.bicep) to add more app settings

The second deployment will overwrite the app settings set by the first deployment, resulting in only the new app settings being present.

> The sample uses a Function App, but the same applies to all sites.
