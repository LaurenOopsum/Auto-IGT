

class_name GlossItem
extends Node


var attributes : Dictionary # only nodes of type "item" have these
var node_value : String     # also only "item" type nodes


func add_attribute(att_name : String, att_value : String) :
	attributes[att_name] = att_value


func get_value(attribute_name : String) -> String :
	return attributes[attribute_name]


func get_attribute_list() -> Array :
	return attributes.keys()


func get_attribute_values() -> Array :
	return attributes.values()


func add_atts_to_dict() :
	if not get_parent() is GlossTree :
		var parent_type : int = get_parent().node_type
		var row_atts := ""
		for att in attributes :
			row_atts += "-" + attributes[att]
		row_atts = row_atts.lstrip("-")
		
		if !V.level_attributes[parent_type].has(row_atts) :
			V.level_attributes[parent_type].append(row_atts)
