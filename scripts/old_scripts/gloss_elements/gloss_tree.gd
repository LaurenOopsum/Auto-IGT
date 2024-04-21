
#class_name GlossTree
extends Node


func create_example_rows(start_num : String) -> Array :
	var chosen_phrase := get_phrase_numbered(start_num)
	# Doesn't appear to be saving the text for segnum types...???
	return chosen_phrase.get_phrase_rows()


## Finds the phrase of the specified phrase number and returns it
func get_phrase_numbered(start_num : String) -> Phrase :
	print("get phrase numbered")
	for child in get_children() :
		if child is Phrase :
			print("child is phrase")
			if child.get_phrase_row("segnum") == start_num :
				return child
		print("child is NOT phrase")
	print("return null phrase")
	return null


func is_right_phrase_num(phrase : Phrase, start_num : String) -> bool :
	for child in phrase.get_children() :
		if child is XMLItem :
			print("CHILD TYPE")
			print(child.type)
			if child.type == "segnum" && child.text == start_num :
				return true
	return false
