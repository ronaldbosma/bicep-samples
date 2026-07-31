@export()
func flattenTags(tags { * : string }) string[] => map(items(tags), tag => '${tag.key}: ${tag.value}')
