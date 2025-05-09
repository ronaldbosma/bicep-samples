import { flattenTags } from './flatten-tags.bicep'

// Arrange
param tags object

param expectedResult string[]

// Act
var actualResult = flattenTags(tags)

// Assert
assert assertResult = actualResult == expectedResult
