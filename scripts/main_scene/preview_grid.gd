extends VBoxContainer

var gloss_grid : GridContainer
var phrase : GlossNode

func create_preview(rows_data : Array) :
	phrase = set_phrase()
	if V.end : print("Multiple phrases not yet supported")
	else : 
		for template in rows_data :
			if [C.TYPE_NAMES[C.TYPE.PARAGRAPH], C.TYPE_NAMES[C.TYPE.PHRASE]].has(template[0].to_lower()) : 
				create_single_row(template)
			else : print("Grid preview line")

## Creates a non-grid row in the preview
func create_single_row(template : Array) :
	var type := C.TYPE_NAMES.find(template[0].to_lower())
	print(type)
	match type :
		C.TYPE.PARAGRAPH : print("Pass paragraph")
		C.TYPE.PHRASE : new_phrase(template)


func new_phrase(template : Array) :
	var phrase_label := Label.new()


func set_phrase() :
	print("Set phrase")
	_grab_phrase(V.gloss_tree)


func _grab_phrase(node : Node) :
	for item in node.get_children() :
		if node is GlossNode && C.TYPE_NAMES.find(node.node_type) == C.TYPE.PHRASE :
			print(node.node_type)
			if item.node_type == "item" && is_set_phrase(item) :
				phrase = node
		else : _grab_phrase(item)


func is_set_phrase(phrase : GlossNode) -> bool :
	for x in phrase.attributes :
		if phrase.attributes[x] == "segnum" && phrase.node_value == str(V.start) :
			return true
	return false


## Get array of rows data
## If any are not "phrase" or "paragraph"
	## Get word count (1 time)
	## Create grid (1 time ish)
	## Find associated word
	## Add to grid
