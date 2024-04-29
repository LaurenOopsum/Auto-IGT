## Main node for elements used in the gloss

class_name GlossNode
extends Node


var node_type : int # C.TYPE


## Checks if this node matches the type of a row template
## Works on the gloss element level and checks for items
## REALLLLY need to make the items their own class
func is_match(match_attributes : PoolStringArray) -> bool :
	for child in get_children() :
		if child is GlossItem :
			var attribute_vals : Array = child.attributes.values()
			var matches := true
			for val in attribute_vals :
				if !match_attributes.has(val) : matches = false
			if matches : return true
	return false

## Returns the count of descendants of this node
## that are of the specified type
func get_type_count(type : int) -> int :
	var count := 0
	for child in get_children() :
		if child.node_type == C.TYPE_NAMES[type] :
			count += 1
		else : count += get_type_count(child)
	return count

## Returns an array of descendants of this node
## that are of a specified type
func get_type_array(type : int) -> Array :
	var array := []
	for child in get_children() :
		if child.node_type == C.TYPE_NAMES[type] :
			array.append(child)
		else : array.append_array(child.get_type_array(type))
	return array


func add_to_dict() :
	if !V.level_attributes.has(node_type) :
		V.level_attributes[node_type] = []



