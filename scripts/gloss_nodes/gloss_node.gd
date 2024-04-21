
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
