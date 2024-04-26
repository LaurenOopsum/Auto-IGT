## Holds templates for preview generation

extends VBoxContainer

signal create_preview(row_templates)


func generate_format_rows() :
	set_levels_attributes()
	run_templates()

## Run correct function for set template
func run_templates() :
	match V.preset_format :
		C.PRESET.MORPH3 :
			create_preset_format_rows(C.PRESET_TEMPLATES[C.PRESET.MORPH3])
		C.PRESET.MORPH4 : 
			create_preset_format_rows(C.PRESET_TEMPLATES[C.PRESET.MORPH4])
		C.PRESET.WORD3 : 
			create_preset_format_rows(C.PRESET_TEMPLATES[C.PRESET.WORD3])
		C.PRESET.WORD4 : 
			create_preset_format_rows(C.PRESET_TEMPLATES[C.PRESET.WORD4])
		C.PRESET.CUSTOM : create_blank_rows()

## Generate a preset
func create_preset_format_rows(rows_values_array : Array) :
	var row_num := 1
	clear_rows()
	V.line_count = rows_values_array.size()
	$RowCount/RowTotal.text = str(V.line_count)
#	var row_num := 0
	for row in rows_values_array :
		var new_row := C.get_row_template()
		new_row.setup_row(row_num, row)
		row_num += 1
		add_child(new_row)

## Add rows for custom format
func create_blank_rows() :
	for x in V.line_count :
		var new_row := C.get_row_template()
		new_row.setup_blank_row(x+1)
		add_child(new_row)

## Remove all template rows
func clear_rows() :
	#add_child(V.gloss_tree)
	for child in get_children() :
		if child is RowDef : child.queue_free()

## Set the valid attributes of each line at each level of glossing
func set_levels_attributes() :
	V.level_attributes.clear()
	_cycle_nodes(V.gloss_tree.get_children())
#	print(V.level_attributes)

## Cycles through all nodes to grab attributes
func _cycle_nodes(node_array : Array) :
	for node in node_array :
	#	var node_attributes : Array
		# If not an item, add to the dictionary
		if node.node_type != "item" : 
			node.add_to_dict()
			_cycle_nodes(node.get_children())
		# If an item, add attributes to dictionary entry
		else : node.add_atts_to_dict()


## Changes the displayed number of template rows
## when the text is changed
func _on_RowTotal_changed(new_total : String) :
	if new_total != "" && V.gloss_tree :
		var diff := int(new_total) - V.line_count
		
		if diff > 0 :
			for x in diff :
				var new_row : RowDef = load("res://scenes/row_def.tscn").instance()
				new_row.setup_blank_row(x + 1 + V.line_count)
				add_child(new_row)
		elif diff < 0 :
			var lines := get_children()
			for x in -diff :
				if lines.size() > 1 :
					lines.pop_back().queue_free()
		V.line_count = int(new_total)

## Grabs the row templates and sends them through
## to be made into previews
func _on_GeneratePreview_pressed():
# warning-ignore:unassigned_variable
	var rows_array : Array
	
	for x in get_children() :
		if x is RowDef :
			rows_array.append(x.get_settings())
	
	emit_signal("create_preview", rows_array)

