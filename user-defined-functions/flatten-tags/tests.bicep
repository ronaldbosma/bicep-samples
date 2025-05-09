//=============================================================================
// Tests for the flattenTags function
// 
// - Run the tests with the command:  bicep test .\tests.bicep
//=============================================================================

test FlattenTags_MultipleTags_StringArrayWithConcatenatedKeyValuePairsReturned 'test-flatten-tags.bicep' = {
  params: {
    tags: {
      key1: 'value1'
      key2: 'value2'
      key3: 'value3'
    }
    expectedResult: [
      'key1: value1'
      'key2: value2'
      'key3: value3'
    ]
  }
}

test FlattenTags_EmptyTagsObject_EmptyArrayReturned 'test-flatten-tags.bicep' = {
  params: {
    tags: { }
    expectedResult: [ ]
  }
}
