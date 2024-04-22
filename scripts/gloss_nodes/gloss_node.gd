
class_name GlossNode
extends Node


var node_type : String
var attributes : Dictionary
var node_value : String


func add_attribute(att_name : String, att_value : String) :
	attributes[att_name] = att_value


func get_value(attribute_name : String) -> String :
	return attributes[attribute_name]


func get_attribute_list() -> Array :
	return attributes.keys()


func is_match(match_attributes : PoolStringArray) -> bool :
	var attribute_vals := attributes.values()
	var matches := 0
	for val in attribute_vals :
		if match_attributes.has(val) : matches += 1
	if matches == match_attributes.size() : return true
	return false
