## A node that represents an XML morpheme element

class_name Morpheme
extends Node


func get_item_text(row_name : String) -> String :
	for child in get_children() :
		if child is XMLItem && child.type == row_name :
			return child.text
	return ""
