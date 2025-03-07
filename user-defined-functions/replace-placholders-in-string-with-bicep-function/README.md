# Replace placeholders in string

This folder contains an example on how to replace placeholders in a string using user-defined functions in Bicep. See the blog post [Replace placeholders in string with user-defined Bicep function](https://ronaldbosma.github.io/blog/2024/06/21/replace-placeholders-in-string-with-user-defined-bicep-function/) for more information. 

The Bicep Test Framework is used to test the functions. You can run the tests using the following command:

```bash
bicep test .\tests.bicep
```

Files:
- [replace-placeholders.bicep](./replace-placeholders.bicep): contains user-defined functions to replace placeholders.
- [tests.bicep](./tests.bicep): contains tests for the `replacePlaceholders` function.
- [test-replace-placeholders.bicep](./test-replace-placeholders.bicep): helper Bicep file used by `tests.bicep` to test the `replacePlaceholders` function.
- [bicepconfig.json](./bicepconfig.json): Bicep configuration file to enable the experimental test framework.

Documentation:
- [User-defined functions in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/user-defined-functions)
- [Imports in Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/bicep-import)
- [Exploring the awesome Bicep Test Framework](https://rios.engineer/exploring-the-bicep-test-framework-%F0%9F%A7%AA/)
