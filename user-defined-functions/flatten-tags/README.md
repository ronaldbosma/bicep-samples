# Flatten Tags

Most Azure resources support tags, which are key-value pairs. 
However, some resources only support an array of strings as tags.
For example, Entra ID resources like applications and service principals.

This folder contains an example on how to flatten a tags object into an array of strings.

The Bicep Test Framework is used to test the functions. You can run the tests using the following command:

```bash
bicep test .\tests.bicep
```

Files:
- [flatten-tags.bicep](./flatten-tags.bicep): contains user-defined function `flattenTags` to flatten tags.
- [tests.bicep](./tests.bicep): contains tests for the `flattenTags` function.
- [test-flatten-tags.bicep](./test-flatten-tags.bicep): helper Bicep file used by `tests.bicep` to test the `flattenTags` function.
- [bicepconfig.json](./bicepconfig.json): Bicep configuration file to enable the experimental test framework.

Documentation:
- [User-defined functions in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-functions)
- [Imports in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-import)
- [Exploring the awesome Bicep Test Framework](https://rios.engineer/exploring-the-bicep-test-framework-%F0%9F%A7%AA/)
