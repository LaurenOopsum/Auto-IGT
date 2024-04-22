## Main node for elements used in the gloss

class_name GlossNode
extends Node


var node_type : String # These should be changed to ints
var attributes : Dictionary # only nodes of type "item" have these
var node_value : String     # also only "item" type nodes
## I should probably make an inherited class for just items


func add_attribute(att_name : String, att_value : String) :
	attributes[att_name] = att_value


func get_value(attribute_name : String) -> String :
	return attributes[attribute_name]


func get_attribute_list() -> Array :
	return attributes.keys()

## Checks if this node matches the type of a row template
func is_match(match_attributes : PoolStringArray) -> bool :
	var attribute_vals := attributes.values()
	var matches := 0
	for val in attribute_vals :
		if match_attributes.has(val) : matches += 1
	if matches == match_attributes.size() : return true
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
		else : array.append_array(get_type_array(child))
	return array
