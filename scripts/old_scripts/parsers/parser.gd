class_name IGTParser
extends XMLParser

var current_phrase : Phrase
var current_word : Word
var current_morpheme : Morpheme
var current_item : XMLItem

var gloss_tree : GlossTree


#func parse_igt(xml_byte_array : PackedByteArray) -> GlossTree:
#	open_buffer(xml_byte_array)
#	grow_tree()
	
#	return gloss_tree



func grow_tree() :
	while read() == OK :
		# Create new elements as they're encountered in the XML file
		if get_node_type() == XMLParser.NODE_ELEMENT :
			match get_node_name() :
				"interlinear-text" : gloss_tree = GlossTree.new()
				"phrase" : create_new_phrase()
				"word" : create_new_word()
				"morph" : create_new_morpheme()
				"item" : create_new_item()
		# Close elements to editing when their branches close
		elif get_node_type() == XMLParser.NODE_ELEMENT_END :
			match get_node_name() :
				"interlinear-text" : return
				"phrase" : current_phrase = null
				"word" : current_word = null
				"morph" : current_morpheme = null
				"item" : current_item = null
		# Hangle text nodes
		elif get_node_type() == XMLParser.NODE_TEXT :
			set_element_text()


## Creates a new phrase and sets it as active
func create_new_phrase() : 
	var new_phrase := Phrase.new()
	gloss_tree.add_child(new_phrase)
	current_phrase = new_phrase


func create_new_word() : 
	var new_word := Word.new()
	current_phrase.add_child(new_word)
	current_word = new_word


func create_new_morpheme() : 
	var new_morpheme := Morpheme.new()
	current_word.add_child(new_morpheme)
	current_morpheme = new_morpheme


func create_new_item() : 
	var item_parent
	var parent_index := 0
	while !item_parent && parent_index < 3 :
		var parent_branches := [current_morpheme, current_word, current_phrase]
		item_parent = parent_branches[parent_index]
		parent_index += 1
	
	if item_parent :
		var new_item := XMLItem.new()
		new_item.type = get_named_attribute_value_safe("type")
		new_item.lang = get_named_attribute_value_safe("lang")
		current_item = new_item
		item_parent.add_child(new_item)


func set_element_text() :
	var found_text = get_node_data()
	if found_text.contains("\r") : pass
	elif current_item : current_item.text = found_text
	


