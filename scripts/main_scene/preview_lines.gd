## Generates and displays the lines of preview text

extends VBoxContainer

signal send_phrase(phrase_node, rows_data)

var phrase : GlossNode
var words_array := []


func create_preview(rows_data : Array) :
	for child in get_children() : child.queue_free()
	if phrase && phrase.grid : phrase.grid = null
	words_array = []
	grab_phrase(V.gloss_tree) # Set the desired phrase to gloss
#	if phrase.grid : phrase.grid = null
	print(phrase)
	if V.end : print("Multiple phrases not yet supported")
	else : 
		for template in rows_data : print_preview_row(template)
	emit_signal("send_phrase", phrase, rows_data)


## Sets the active phrase to gloss
func grab_phrase(node : Node) :
	for item in node.get_children() :
		if node is GlossNode && node.node_type == C.TYPE.PHRASE :
			if item is GlossItem && _is_set_phrase(item) :
				phrase = node
				phrase.clear_grids()
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
				phrase_label.format(template)
				add_child(phrase_label)
				return

## Returns true if a phrase is the one selected by the user
## Returns false otherwise
func _is_set_phrase(cur_phrase : GlossItem) -> bool :
	for x in cur_phrase.get_attribute_values() :
		if x == "segnum" && cur_phrase.node_value == str(V.start) : 
			return true
	return false

## Adds a row of the gloss that is aligned at the word level
func add_word_row(template : Array) :
	_set_phrase_grid() ## Need to clear these grids??
	_set_words_array()
	for word in words_array :
		if word.grid : word.grid = null
	# The PreviewLabels that will be displayed on screen
	var word_labels := _create_labels(template, words_array)
	# Set grid to the right number of columns
	word_labels = phrase.grid._adjust_row_length(word_labels)
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


func _create_labels(template : Array, array : Array) -> Array :
	var labels := []
	var match_pattern : PoolStringArray = template[1].split("-")

	for x in array :
		var items : Array = x.get_matching_items(match_pattern)
		var label := PreviewText.new()
		label.level = template[0] 
		if items.size() > 0 : 
			label.text = items[0].node_value
			label.format(template)
		
		labels.append(label)
	
	return labels


func add_morph_row(template : Array) :
	_set_phrase_grid() # Need to clear grids??
	_set_words_array()
	
	var m_grids := []
	
	for word in words_array :
		if !word.grid || !is_instance_valid(word.grid) : 
			word.grid = PreviewGrid.new()
		if !m_grids.has(word.grid) : 
			m_grids.append(word.grid)

		var morphs_array : Array = word.get_type_array(template[0])
		var morphs_labels : Array = _create_labels(template, morphs_array)
		morphs_labels = word.grid._adjust_row_length(morphs_labels)
		
		for morph in morphs_labels :
			word.grid.add_child(morph)

		
	
	m_grids = phrase.grid._adjust_row_length(m_grids)
	
	for grid in m_grids :
		if !grid.is_inside_tree() : phrase.grid.add_child(grid)


