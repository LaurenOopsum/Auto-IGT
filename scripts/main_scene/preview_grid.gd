extends VBoxContainer

var gloss_grid : GridContainer
var phrase : GlossNode

func create_preview(rows_data : Array) :
	_grab_phrase(V.gloss_tree)
	if V.end : print("Multiple phrases not yet supported")
	else : 
		for template in rows_data :
			if [C.TYPE_NAMES[C.TYPE.PARAGRAPH], C.TYPE_NAMES[C.TYPE.PHRASE]].has(template[0].to_lower()) : 
				create_single_row(template)
			else : add_grid_row(template)

## Creates a non-grid row in the preview
func create_single_row(template : Array) :
	if gloss_grid : gloss_grid = null
	var type := C.TYPE_NAMES.find(template[0].to_lower())
	match type :
		C.TYPE.PARAGRAPH : print("Pass paragraph")
		C.TYPE.PHRASE : new_phrase(template)


func add_grid_row(template : Array) :
	if !gloss_grid : _add_new_gloss_grid()


func _add_new_gloss_grid() :
	gloss_grid = GridContainer.new()
	gloss_grid.columns = get_word_count(phrase)


func get_word_count(node : GlossNode) -> int :
	var word_count := 0
	for child in node.get_children() :
		if child.node_type == C.TYPE_NAMES[C.TYPE.WORD] :
			word_count += 1
		else : word_count += get_word_count(child)
	print(word_count)
	return word_count


func new_phrase(template : Array) :
	var phrase_label := Label.new()
	var row_template : PoolStringArray = template[1].split("-")
	print(row_template)
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
				print("Set node to phrase")
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
