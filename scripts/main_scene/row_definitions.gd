extends VBoxContainer

signal create_preview(row_templates)


func generate_format_rows() :
	set_levels_attributes()
	run_templates()


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


func create_preset_format_rows(rows_values_array : Array) :
	var row_num := 1
	clear_rows()
	V.line_count = rows_values_array.size()
	$RowCount/RowTotal.text = str(V.line_count)
	for row in rows_values_array :
		var new_row : RowDef = load("res://scenes/row_def.tscn").instance()
		new_row.setup_row(row_num, row)
		row_num += 1
		add_child(new_row)


func create_blank_rows() :
	for x in V.line_count :
		var new_row : RowDef = load("res://scenes/row_def.tscn").instance()
		new_row.setup_blank_row(x+1)
		add_child(new_row)


func clear_rows() :
	#add_child(V.gloss_tree)
	for child in get_children() :
		if child is RowDef : child.queue_free()

### The attributes aren't working right.
### Need to get V.level_attributes into a functioning Dictionary
func set_levels_attributes() :
	V.level_attributes.clear()
	cycle_nodes(V.gloss_tree.get_children())


func cycle_nodes(node_array : Array) :
	for node in node_array :
		var node_attributes : Array
		if node.node_type != "item" : 
			add_to_dict(node)
			node_attributes = get_node_attributes(node)
			add_new_attrbts(node.node_type, node_attributes)
			cycle_nodes(node.get_children())
	#	else : _node_attrbts(node)


func add_new_attrbts(type : String, att_array : Array) :
	var lvl_array : Array = V.level_attributes[type]
	for att in att_array :
		if !lvl_array.has(att) : lvl_array.append(att)


func add_to_dict(gloss_node : GlossNode) :
	if !V.level_attributes.has(gloss_node.node_type) :
		V.level_attributes[gloss_node.node_type] = []


func get_node_attributes(gloss_node : GlossNode) -> Array :
# warning-ignore:unassigned_variable
	var attribute_array : Array
	for node in gloss_node.get_children() :
		if node.node_type == "item" : attribute_array.append(_node_attrbts(node))
	return attribute_array


func _node_attrbts(node : GlossNode) -> String :
	var att_row_def := ""
	for att in node.get_attribute_list() :
		att_row_def += ("-" + node.attributes[att])
	att_row_def = att_row_def.lstrip("-")
	return att_row_def


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


func _on_GeneratePreview_pressed():
# warning-ignore:unassigned_variable
	var rows_array : Array
	
	for x in get_children() :
		if x is RowDef :
			rows_array.append(x.get_settings())
	
	emit_signal("create_preview", rows_array)

