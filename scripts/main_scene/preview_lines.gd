## Generates and displays the lines of preview text

extends VBoxContainer

#var gloss_grid : GridContainer

var phrase : GlossNode
var words_array := []


func create_preview(rows_data : Array) :
	for child in get_children() : child.queue_free()
	grab_phrase(V.gloss_tree) # Set the desired phrase to gloss
	if V.end : print("Multiple phrases not yet supported")
	else : 
		for template in rows_data : print_preview_row(template)


## Sets the active phrase to gloss
func grab_phrase(node : Node) :
	for item in node.get_children() :
		if node is GlossNode && node.node_type == C.TYPE.PHRASE :
			if item is GlossItem && _is_set_phrase(item) :
				phrase = node
		else : grab_phrase(item)

## Displays each row of the gloss on screen
## Only does phrase, word, and morph level right now
func print_preview_row(template : Array) :
	match template[0] :
		C.TYPE.PHRASE : add_phrase_row(template)
		C.TYPE.WORD : add_word_row(template)
		C.TYPE.MORPH : add_morph_row(template)

## Creates a non-aligned row of text in the preview
func add_phrase_row(template : Array) :
	if phrase.grid : phrase.grid = null
	var type : int = template[0]
	_add_new_phrase(template)

## Displays a phrase on the preview
## A single row with no vertical alignment
func _add_new_phrase(template : Array) :
	var phrase_label := PreviewText.new()
	phrase_label.level = template[0]
	var row_template : PoolStringArray = template[1].split("-")
	for item in phrase.get_children() :
		if item is GlossItem :
			var is_match := true
			for att in item.get_attribute_list() :
				if !row_template.has(item.attributes[att]) : is_match = false
			if is_match : 
				phrase_label.text = item.node_value
				add_child(phrase_label)
				return

## Returns true if a phrase is the one selected by the user
## Returns false otherwise
func _is_set_phrase(cur_phrase : GlossItem) -> bool :
	for x in cur_phrase.attributes :
		if cur_phrase.attributes[x] == "segnum" && cur_phrase.node_value == str(V.start) : 
			return true
	return false

## Adds a row of the gloss that is aligned at the word level
func add_word_row(template : Array) :
	_set_phrase_grid()
	_set_words_array()
	# The PreviewLabels that will be displayed on screen
	var word_labels := _create_word_labels(template)
	# Set grid to the right number of columns
	if phrase.grid.get_child_count() != 0 :
		word_labels = _adjust_row_length(word_labels)
	else : phrase.grid.columns = word_labels.size()
	# add the new row at word-level
	for word in word_labels :
		phrase.grid.add_child(word)


func _set_phrase_grid() :
	if !phrase.grid : 
		phrase.grid = PreviewGrid.new()
		add_child(phrase.grid)


func _set_words_array() :
	if words_array.empty() :
		words_array = phrase.get_type_array(C.TYPE.WORD)


func _create_word_labels(template : Array) -> Array :
	var word_labels := []
	var match_pattern : PoolStringArray = template[1].split("-")

	for word in words_array :
		var items : Array = word.get_matching_items(match_pattern)
		var label := PreviewText.new()
		label.level = template[0] # == C.TYPE.WORD
		if items.size() > 0 : label.text = items[0].node_value
		word_labels.append(label)
	
	return word_labels


func _adjust_row_length(word_labels : Array) -> Array :
	var diff := word_labels.size() - phrase.grid.columns
	# fill out the rest of the previous row
	# increase column count
	if diff > 0 : 
		for x in diff :
			var filler := Control.new()
			phrase.grid.add_child(filler)
		phrase.grid.columns = word_labels.size()
	# fill out the rest of the array to a full row
	elif diff < 0 :
		for x in diff :
			var filler := Control.new()
			word_labels.append(filler)
	
	return word_labels


func add_morph_row(template : Array) :
	pass
