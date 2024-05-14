## Base class for Resource scripts that copy IGT to clipboard

class_name Xerox
extends GDScript



var phrase : GlossNode
var rows_data : Array


func copy(phrase_node : GlossNode, data : Array) :
	phrase = phrase_node
	rows_data = data
	var markup := get_constant()
	clipboard_copy(markup)


func get_constant() -> int : # Returns the enum for the markup language
	return -1


## Overwrite this function in descendent Xeroxes
func clipboard_copy(markup : int) : 
	var open_string : String = C.MARKUP_TEXT[markup][C.BLOCK.CODE_OPEN]
	var row_node_arrays := get_row_node_arrays()
	var col_count := get_col_count(row_node_arrays)
	var col_definition := define_columns(col_count)
	var row_block := print_markup_rows(row_node_arrays, col_count, markup) 
	var close_string : String = C.MARKUP_TEXT[markup][C.BLOCK.CODE_CLOSE]
	var markup_string := assemble_string(open_string, col_definition, row_block, close_string)
	OS.set_clipboard(markup_string)

## Grabs the GlossNodes associated with each row
func get_row_node_arrays() -> Array :
	var row_node_arrays := []
	
	for template in rows_data :
		if template[0] == C.TYPE.PHRASE : 
			row_node_arrays.append([phrase])
		else :
			var type_array := phrase.get_type_array(template[0])
			type_array = _trim_type_array(type_array, _get_pattern(template))
			row_node_arrays.append(type_array)
	
	return row_node_arrays

## Removes nodes that don't match
func _trim_type_array(type_array : Array, match_array : PoolStringArray) :
	var to_delete := []
	
	for type_node in type_array :
		var t_items : Array = type_node.get_matching_items(match_array)
		if t_items.empty() : to_delete.append(type_node)
	
	for x in to_delete :
		type_array.erase(x)
	
	return type_array


func _get_pattern(template : Array) -> PoolStringArray :
	return template[1].split("-")


func get_col_count(row_node_arrays : Array) -> int :
	var cols := 1
	for row in row_node_arrays :
		if row.size() > cols : cols = row.size()
	return cols

## Overwrite in descendent class
## Defines the number of columns in the markup language
func define_columns(_col_count : int) -> String :
	return ""


func print_markup_rows(row_node_arrays : Array, col_count : int, markup : int) -> String :
	var rows_string_block := ""
	
	var match_patterns = rows_data.duplicate()
	
	for row in row_node_arrays :
		var template : Array = match_patterns.pop_front()
		match row[0].node_type :
			C.TYPE.PHRASE : rows_string_block += _mu_phrase_row(row, col_count, template, markup)
			C.TYPE.WORD : rows_string_block += _mu_word_row(row, row_node_arrays, template, markup)
			C.TYPE.MORPH : rows_string_block += _mu_morph_row(row, template, markup)
	
	return rows_string_block


func _mu_phrase_row(row : Array, col_count : int, template : Array, markup : int) -> String : 
	var row_open : String = C.MARKUP_TEXT[markup][C.BLOCK.ROW_OPEN]
	var row_text := add_multicol_val(row[0], template, col_count, markup)
	var row_close : String = C.MARKUP_TEXT[markup][C.BLOCK.ROW_CLOSE]
	return row_open + row_text + row_close


func _mu_word_row(row : Array, row_node_arrays : Array, template : Array, markup : int) -> String : 
	var row_open : String = C.MARKUP_TEXT[markup][C.BLOCK.ROW_OPEN]
	var row_text := ""
	var row_close : String = C.MARKUP_TEXT[markup][C.BLOCK.ROW_CLOSE]
	
	var morph_locs := _get_morph_locations(row_node_arrays)
	
	if morph_locs.size() > 0 : 
		var morph_row : Array = row_node_arrays[morph_locs[0]]
		row_text += _set_words_yes_morphs(row, morph_row, template, markup)
	else : row_text += _set_words_no_morphs(row, template, markup)
	
	return row_open + row_text + row_close


func _get_morph_locations(row_node_arrays : Array) -> PoolIntArray :
	var locations : PoolIntArray = []
	var index := 0
	for row in row_node_arrays :
		if row[0].node_type == C.TYPE.MORPH :
			locations.append(index)
		index += 1
	return locations


func _set_words_yes_morphs(row : Array, morph_row : Array, template : Array, markup : int) -> String :
	var markup_string := ""
	for word in row :
		var morph_count := 0
		for morph in morph_row :
			if morph.get_parent() == word : morph_count += 1
		if morph_count > 1 : 
			markup_string += add_multicol_val(word, template, morph_count, markup)
			markup_string += C.MARKUP_TEXT[markup][C.BLOCK.SEPARATOR]
		else : markup_string += add_single_val(word, template, markup)
	markup_string = markup_string.rstrip(C.MARKUP_TEXT[markup][C.BLOCK.SEPARATOR])
	return markup_string


func _set_words_no_morphs(row : Array, template : Array, markup : int) -> String:
	var markup_text := ""
	for word in row : markup_text += add_single_val(word, template, markup)
	markup_text = markup_text.rstrip(C.MARKUP_TEXT[markup][C.BLOCK.SEPARATOR])
	return markup_text


func _mu_morph_row(row : Array, template : Array, markup : int) -> String : 
	var row_open : String = C.MARKUP_TEXT[markup][C.BLOCK.ROW_OPEN]
	var row_text := ""
	var row_close : String = C.MARKUP_TEXT[markup][C.BLOCK.ROW_CLOSE]
	for morph in row :
		row_text += add_single_val(morph, template, markup)
	row_text = row_text.rstrip(C.MARKUP_TEXT[markup][C.BLOCK.SEPARATOR])
	return row_open + row_text + row_close

## Overwrite in descendent class
func assemble_string(open_string: String, col_definition : String, row_block : String, close_string : String) -> String :
	return open_string + col_definition + row_block + close_string


func add_multicol_val(val : GlossNode, template : Array , col_count : int, markup : int) -> String :
	var multicol_open : String = C.MARKUP_TEXT[markup][C.BLOCK.MULTICOL_OPEN]
	var multicol_mid : String = C.MARKUP_TEXT[markup][C.BLOCK.MULTICOL_MID]
	var mutlicol_close : String = C.MARKUP_TEXT[markup][C.BLOCK.MULTICOL_CLOSE]
	
	var item : Array = val.get_matching_items(_get_pattern(template))
	
	var text : String = item[0].node_value
	text = format(text, template, markup)
	
	return multicol_open + str(col_count) + multicol_mid + text + mutlicol_close


func add_single_val(val : GlossNode, template : Array, markup : int) -> String :
	var cell_open : String = C.MARKUP_TEXT[markup][C.BLOCK.CELL_OPEN]
	var cell_text := ""
	var cell_close : String = C.MARKUP_TEXT[markup][C.BLOCK.CELL_CLOSE]
	var cell_separator : String = C.MARKUP_TEXT[markup][C.BLOCK.SEPARATOR]
	
	var match_items : Array = val.get_matching_items(_get_pattern(template))
	for item in match_items :
		cell_text += format(item.node_value, template, markup)
	return cell_open + cell_text + cell_close + cell_separator


func format(word : String, template : Array, markup : int) -> String :
	if template[4] : word = "'" + word + "'"
	if template[2] : word = C.MARKUP_TEXT[markup][C.BLOCK.ITALIC_OPEN] + word + C.MARKUP_TEXT[markup][C.BLOCK.ITALIC_CLOSE]
	if template[3] : word = C.MARKUP_TEXT[markup][C.BLOCK.BOLD_OPEN] + word + C.MARKUP_TEXT[markup][C.BLOCK.BOLD_CLOSE]
	return word
