
#class_name FlextextParser
extends Node

enum T {XML_NODE, XML_NODE_CLOSE, XML_TEXT}


var xml_array : Array
var element_index : int


var current_phrase : Phrase
var current_word : Word
var current_morpheme : Morpheme
var current_item : XMLItem
#var gloss_tree : GlossTree


func parse_igt(array : Array)  :
	open_array(array)
	grow_tree()
	
	#return gloss_tree


func grow_tree() :
	element_index = 0
	while element_index < xml_array.size() :
		match get_element_type() :
			T.XML_NODE : create_new_element()
			T.XML_NODE_CLOSE : close_element()
			T.XML_TEXT : set_item_text()
		element_index += 1


func create_new_element() :
	match get_element_name() :
#		"interlinear-text" : gloss_tree = GlossTree.new()
		"phrase" : add_new_phrase()
		"word" : add_new_word()
		"morph" : add_new_morpheme()
		"item" : add_new_item()


func close_element() :
	match get_element_name() :
		"phrase" : current_phrase = null
		"word" : current_word = null
		"morph" : current_morpheme = null
		"item" : current_item = null


func set_item_text() :
	var elem_text : int = xml_array[element_index]
	if elem_text && current_item :
		current_item.text = xml_array[element_index]


func add_new_phrase() : 
	var new_phrase := Phrase.new()
#	gloss_tree.add_child(new_phrase)
	current_phrase = new_phrase


func add_new_word() : 
	var new_word := Word.new()
	current_phrase.add_child(new_word)
	current_word = new_word


func add_new_morpheme() :
	var new_morpheme := Morpheme.new()
	current_word.add_child(new_morpheme)
	current_morpheme = new_morpheme


func add_new_item() : 
	var item_parent
	var parent_index := 0
	while !item_parent && parent_index < 3 :
		var parent_branches := [current_morpheme, current_word, current_phrase]
		item_parent = parent_branches[parent_index]
		parent_index += 1
	
	if item_parent :
		var new_item := XMLItem.new()
		new_item.type = get_attribute("type")
		new_item.lang = get_attribute("lang")
		current_item = new_item
		item_parent.add_child(new_item)


func open_array(array : Array) :
	xml_array = array
	element_index = 0

# Returns the value of the given attribute on the current array item
func get_attribute(attribute_name : String) -> String :
	var elem_text : String = xml_array[element_index]
#	elem_text = elem_text.replace("\"", "")
	# Find the attribute name in the String
	var att_start : int = elem_text.find(attribute_name)
	# Find the start of the attribute value
	var val_start : int = elem_text.find("=", att_start) + 2
	# Find the end of the attribute value
	var val_end : int = elem_text.find(" ", val_start)
	if val_end < 0 : val_end = elem_text.find(">", val_start)
	val_end -= 1
	
	var attribute_value := elem_text.substr(val_start, val_end - val_start)
	
	return attribute_value


func get_element_name() -> String :
	var elem_text : String = xml_array[element_index]
	var elem_name : String
	if elem_text[0] == "<" :
		var name_start := 1
		var name_end : int
		var space := elem_text.find(" ", name_start)
		var gr_than := elem_text.find(">", name_start)
		if  space > gr_than : name_end = gr_than
		else : name_end = space - 1
			
		if elem_text[1] == "/" : name_start = 2
		elem_name = elem_text.substr(name_start, name_end)
	else : elem_name = "text"
	return elem_name


func get_element_type() -> int :
	var elem_text : String = xml_array[element_index]
	if elem_text.left(2) == "</" : return T.XML_NODE_CLOSE
	elif elem_text[0] == "<" : return T.XML_NODE
	else : return T.XML_TEXT

