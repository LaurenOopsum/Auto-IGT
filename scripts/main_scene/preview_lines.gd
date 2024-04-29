## Generates and displays the lines of preview text

extends VBoxContainer

var gloss_grid : GridContainer

var phrase : GlossNode
var word_array : Array


func create_preview(rows_data : Array) :
	for child in get_children() : child.queue_free()
	_grab_phrase(V.gloss_tree)
	if V.end : print("Multiple phrases not yet supported")
	else : 
		for template in rows_data :
			if [C.TYPE_NAMES[C.TYPE.PARAGRAPH], C.TYPE_NAMES[C.TYPE.PHRASE]].has(template[0].to_lower()) : 
				create_single_row(template)
			else : add_grid_row(template)

## Creates a non-aligned row of text in the preview
func create_single_row(template : Array) :
	if gloss_grid : gloss_grid = null
	var type := C.TYPE_NAMES.find(template[0].to_lower())
	match type :
		C.TYPE.PARAGRAPH : print("Pass paragraph")
		C.TYPE.PHRASE : new_phrase(template)

## Adds line of text in the preview that is word-aligned
func add_grid_row(template : Array) :

	if !gloss_grid : _add_new_gloss_grid()



## Adds a grid for aligned text, if there isn't already one
func _add_new_gloss_grid() :
	if !word_array : word_array = phrase.get_type_array(C.TYPE.WORD)
	gloss_grid = GridContainer.new()
	gloss_grid.columns = word_array.size()
	if !gloss_grid.get_parent() : add_child(gloss_grid)



func get_row_array(template : Array, source_array : Array) -> Array :
	var row_array := []
	for word in source_array :
		if word.is_match(template[1].split("-")) : row_array.append(word)
		else : row_array.append_array(get_row_array(template, word.get_children()))
	return row_array


func new_phrase(template : Array) :
	var phrase_label := RichTextLabel.new()
	phrase_label.fit_content_height = true
	var row_template : PoolStringArray = template[1].split("-")
	for item in phrase.get_children() :
		if item.node_type == "item" :
			var is_match := true
			for att in item.get_attribute_list() :
				if !row_template.has(item.attributes[att]) : is_match = false
			if is_match : 
				phrase_label.text = item.node_value
				add_child(phrase_label)
				return


func _grab_phrase(node : Node) :
	for item in node.get_children() :
		if node is GlossNode && C.TYPE_NAMES.find(node.node_type) == C.TYPE.PHRASE :
			if item.node_type == "item" && is_set_phrase(item) :
				phrase = node
		else : _grab_phrase(item)


func is_set_phrase(cur_phrase : GlossNode) -> bool :
	for x in cur_phrase.attributes :
		if cur_phrase.attributes[x] == "segnum" && cur_phrase.node_value == str(V.start) : 
			return true
	return false


## Get array of rows data
## If any are not "phrase" or "paragraph"
	## Get word count (1 time)
	## Create grid (1 time ish)
	## Find associated word
	## Add to grid
