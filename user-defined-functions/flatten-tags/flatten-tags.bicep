@export()
func flattenTags(tags object) string[] => map(items(tags), tag => '${tag.key}: ${tag.value}')
