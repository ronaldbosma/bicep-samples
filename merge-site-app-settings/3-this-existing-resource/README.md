# Scenario 3: Use `this.existingResource()` to Merge App Settings

In this scenario, we demonstrate the use of `this.existingResource()` to merge existing app settings with new app settings when deploying to an existing App Service.

To execute this scenario, run the following command where `<your-resource-group>` is the name of your resource group:

```cmd
. .\deploy.ps1 -ResourceGroupName "<your-resource-group>"
```

It will:
- first deploy a storage account and app service using [site.bicep](./site.bicep) with some default app settings
- ask for confirmation to proceed _(before you do, check the app settings in the Azure portal)_
- then it will deploy [additional-app-settings.bicep](./1-no-merge/additional-app-settings.bicep) to add more app settings

**THIS DOESN'T WORK (YET?)**: The second deployment will merge the app settings set by the first deployment, resulting in both the existing and new app settings being present.
If you would run the deployment again, it will keep merging the app settings without overwriting existing ones.

A possible downside of this approach is that app app settings are not removed if they are no longer present in the new app settings.

> The sample uses a Function App, but the same applies to all sites.

## Prerequisites

The `thisNamespace` feature is not yet available in the stable Bicep CLI.
You need to install the nightly Bicep CLI to use this feature. 
You can use this command (see [installing nightly](https://github.com/Azure/bicep/blob/main/docs/installing-nightly.md) for more info):

```cmd
iex "& { $(irm https://aka.ms/bicep/nightly-cli.ps1) }"
```

You'll also need to enable the experimental feature by creating a `bicepconfig.json` file with the following content:

```json
{
  "experimentalFeaturesEnabled": {
    "thisNamespace": true
  }
}
```