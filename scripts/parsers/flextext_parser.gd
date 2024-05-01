## Parses strings of XML into a GlossTree

class_name FlextextParser
extends Parser

enum T {XML_NODE, XML_NODE_CLOSE, XML_TEXT}

## Names of the different types of nodes
const TYPES := [
#	"interlinear-text",
	"paragraph",
	"phrase",
	"word",
	"morph",
	"item",
	"interlinear-text",
	"text"
]

var open_branch : Array # GlossNodes


## Separates file_text into an array of separate code elements
func create_string_array(file_text) :
	file_text = file_text.replace("<", "*<")
	file_text = file_text.replace(">", ">*")
	var string_array : Array = file_text.split("*", false)
# warning-ignore:unassigned_variable
	for item in string_array :
		if not "\n" in item : code_array.append(item)

## Goes through the code_array line by line and builds the GlossTree
func grow_tree() :
	element_index = 0
	while element_index < code_array.size() :
		match get_element_type() :
			T.XML_NODE : open_node()
			T.XML_NODE_CLOSE : close_node()
			T.XML_TEXT : set_item_text()
		element_index += 1
	V.gloss_tree = gloss_tree
	emit_signal("tree_grown")
	queue_free()

## Returns the node type as an enum T
func get_element_type() -> int :
	var elem_text : String = code_array[element_index]
	if elem_text.begins_with("</") : return T.XML_NODE_CLOSE
	elif elem_text.begins_with("<") : return T.XML_NODE
	return T.XML_TEXT
	
## Processes an opening XML tag in the code_array
func open_node() :
	match get_node_type() :
		C.TYPE.IGT : 
			gloss_tree = GlossTree.new()
		C.TYPE.PARAGRAPH, C.TYPE.PHRASE, C.TYPE.WORD, C.TYPE.MORPH :
			add_gloss_node()
		C.TYPE.ITEM : add_gloss_item()

## Closes an open element and removes it from open_branch
func close_node() :
	match get_node_type() :
		C.TYPE.PARAGRAPH, C.TYPE.PHRASE, C.TYPE.WORD, C.TYPE.MORPH :
			if open_branch.back().node_type == get_node_type() :
				open_branch.pop_back()
		C.TYPE.ITEM :
			if open_branch.back() is GlossItem :
				open_branch.pop_back()

## Adds a String in the value var of the last Item in open_branch
func set_item_text() :
	open_branch.back().node_value = code_array[element_index]

## Grabs the name of the current element in the code_array
func get_node_type() -> int :
	var elem_text : String = code_array[element_index]
	var elem_name : String
	if elem_text.begins_with("</") :
		elem_name = elem_text.lstrip("</").rstrip(">")
	elif elem_text.begins_with("<") :
		if " " in elem_text:
			elem_name = elem_text.left(elem_text.find(" ")).lstrip("<")
		else : elem_name = elem_text.lstrip("<").rstrip(">")
	else : elem_name = "text"
	return TYPES.find(elem_name)

## Adds a GlossNode to the GlossTree and open_branch
func add_gloss_node() :
	var new_node := GlossNode.new()
	new_node.node_type = get_node_type()
	if open_branch.empty() || new_node.node_type == C.TYPE.PARAGRAPH :
		gloss_tree.add_child(new_node)
	else : open_branch.back().add_child(new_node)
	open_branch.append(new_node)


func add_gloss_item() :
	var new_item := GlossItem.new()
	if open_branch.empty() && gloss_tree :
		gloss_tree.add_child(new_item)
	elif !open_branch.empty() : 
		open_branch.back().add_child(new_item)
	set_item_attributes(new_item)
	open_branch.append(new_item)


func set_item_attributes(item : GlossItem) :
	var elem_text : String = code_array[element_index]
	var cursor_position := 0
	for x in elem_text.count("=") :
		var equal := elem_text.find("=", cursor_position)
		var name_start := elem_text.rfind(" ", equal) + 1
		var att_name := elem_text.substr(name_start, equal - name_start)
		
		var value_end := elem_text.find(" ", equal)
		equal += 1
		if value_end < 0 : value_end = elem_text.find(">", equal)
		var att_value := elem_text.substr(equal, value_end - equal)
		att_value = att_value.replace("\"", "")
		
		item.add_attribute(att_name, att_value)
		
		cursor_position = equal
	
