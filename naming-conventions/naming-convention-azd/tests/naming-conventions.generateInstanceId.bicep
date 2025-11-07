// ==================================================================================
// Helper file to call the generateInstanceId function in tests and assert the result
// ==================================================================================

// Arrange

import { generateInstanceId } from '../naming-conventions.bicep'

param environment string
param region string

param expectedResult string

// Act
var actualResult = generateInstanceId(environment, region)

// Assert
assert assertResult = actualResult == expectedResult
