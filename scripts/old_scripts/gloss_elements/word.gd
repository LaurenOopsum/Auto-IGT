## A node that represents and XML word element

class_name Word
extends Node


func get_word_row_text(row_name : String) -> String :
	for child in get_children() :
		if child is XMLItem && child.type == row_name : 
			return child.text
	return ""


func get_row_text_from_morpheme(row_name : String) -> Array :
	var return_row : Array
	for child in get_children() :
		if child is Morpheme :
			return_row.append(child.get_item_text(row_name))
	return return_row

