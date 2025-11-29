# Using `this.existingResource()` to merge site app settings

I've had several projects with a separation in platform and application teams. 
The platform team is responsible for deploying the infrastructure, including App Services, while the application team deploys the application code. 
In such scenarios, the platform team often configures default app settings required for the App Service, and the application team adds application specific app settings.

If you don't take this into account, deploying the application code with its app settings would overwrite the existing app settings set by the platform team and vice versa. 
This is show in scenario [1-no-merge](./1-no-merge/).

I ussually create a separate [merge-app-settings.bicep](./2-merge-with-module/merge-app-settings.bicep) module that merges the existing app settings with the new ones.
This module should be used in both the platform and application deployments to ensure that app settings are merged correctly.
This is shown in scenario [2-merge-with-module](./2-merge-with-module/).

With the introduction of the `this` namespace in Bicep, we can now simplify this process by using `this.existingResource()` to get the existing app settings directly within the same Bicep file.
This eliminates the need for a separate module to merge app settings, as shown in scenario [3-this-existing-resource](./3-this-existing-resource/).
The blog post [How to use the `this` namepsace in Bicep to check resources](https://www.idontlikeai.dev/how-to-use-the-this-namepsace-in-bicep-to-check-resources/) by Gijs Reijn gives a great overview of the new `this` namespace in Bicep.
