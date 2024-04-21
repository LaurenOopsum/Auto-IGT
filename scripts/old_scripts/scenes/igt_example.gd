extends VBoxContainer

var latex_col_count : int
var column_spans : Array


func _on_igt_rows_created(rows_array : Array) :
	var new_row
	while !rows_array.empty() :
		var row = rows_array.pop_front()
		if row is String : new_row = add_string(row)
		elif row is Array : new_row = get_row_grid(rows_array)
		if new_row : add_child(new_row)


func add_string(string : String) -> Label :
	var new_row_string := Label.new()
	new_row_string.text = string
	return new_row_string

## Creates the grid container that displays the example gloss
func get_row_grid(rows_array : Array) -> GridContainer :
	var new_rows_grid : GridContainer
#	rows_array = remove_empties(rows_array)
	while !rows_array.empty() :
		var row = rows_array.pop_front()
		if row is String : # phrase level
			rows_array.insert(0, row)
			return new_rows_grid
		elif row is Array : # create a new grid if there isn't one
#			row = remove_empties(row)
			if !new_rows_grid : new_rows_grid = _new_grid_rows(row.size())
			for column in row : # word level
				if column is String :
					new_rows_grid.add_child(add_string(column))
				elif column is Array : # morpheme level
#					column = remove_empties(column)
					var hbox := HBoxContainer.new()
					for string in column : 
						hbox.add_child(add_string(string))
					new_rows_grid.add_child(hbox)
	return new_rows_grid


func _new_grid_rows(column_count : int) -> GridContainer :
	var new_grid_container := GridContainer.new()
	new_grid_container.columns = column_count
	return new_grid_container


func remove_empties(array : Array) -> Array :
	var items_to_erase := []
	for item in array :
		if item is String && item == "" : items_to_erase.append(item)
		elif item is Array && item == [] : items_to_erase.append(item)
	for item in items_to_erase :
		array.erase(item)
	return array

### Functions to create the LaTeX string ##

func _on_copy_latex_pressed() :
	var latex_body := create_latex_string()
	var latex_onset :=  "\\begin{tabular}{" + _latex_col_def() + "}\n"
	var latex_offset := "\\end{tabular}"
	var latex_string = latex_onset + latex_body + latex_offset
	OS.set_clipboard(latex_string)
#	DisplayServer.clipboard_set(latex_string)


func _latex_col_def() -> String :
	var columns := ""
	for x in latex_col_count :
		columns += " l"
	columns += " "
	return columns


func create_latex_string() -> String :
	var latex_string := ""
	## Generates the LaTeX string row by row ##
	for node in get_children() : # for row/grid in example
		if node is Label : # if it's a single label
			latex_string += full_row_label(node)
		elif node is GridContainer : # if it's a grid
			set_column_spans(node)
			latex_string += latex_rows_from_grid(node) 
	return latex_string


func full_row_label(label : Label) -> String :
	var latext := "\t" + _set_multicol_label(label, latex_col_count) + " \\\\\n"
	return latext


func latex_rows_from_grid(grid : GridContainer) -> String :
#	var grid := _reverse_grid_order(rev_grid)
	var latext := ""
	var row_count := grid.get_child_count() / grid.columns
	var row_num := 0
	for x in row_count : 
		latext += "\t" + latex_grid_row(grid, row_num)
		row_num += 1
	
	return latext


#func _reverse_grid_order(rev_grid : GridContainer) -> GridContainer :
#	var new_grid := GridContainer.new()
#	new_grid.columns = rev_grid.columns
#	var child_list := rev_grid.get_children()
#	while child_list.size() > 0 :
#		var grid_item = child_list.pop_back()
#		new_grid.add_child(grid_item.duplicate())
#	return new_grid


func latex_grid_row(grid : GridContainer, row_num : int) -> String :
	var row_text := ""
	var item_index := row_num * grid.columns
	for x in grid.columns : # iterate across each item in a row
		var current_item = grid.get_child(item_index)
		var col_span := _get_column_span(item_index, grid)
		if current_item is HBoxContainer : 
			row_text += _latex_string_from_hbox(current_item, col_span)
		elif current_item is Label :
			if col_span > 1 : 
				row_text += _set_multicol_label(current_item, col_span) + " & "
			else : row_text += current_item.text + " & "
		
		item_index += 1
	
	row_text = row_text.rstrip("& ")
	row_text += " \\\\\n"
	return row_text


func _latex_string_from_hbox(current_item : HBoxContainer, col_span : int) -> String :
	var hbox_string := ""
	var children := current_item.get_child_count()
	if children == col_span :
		for label in current_item.get_children() :
			hbox_string += _add_label_text(label)
	elif children == 1 :
		hbox_string += _set_multicol_label(current_item.get_child(0), col_span) + " & "
	else : hbox_string += "OTHER AMOUNT"
	return hbox_string


func _set_multicol_label(label : Label, columns : int) -> String :
	return "\\multicolumn{" + str(columns) + "}{ l }{" + label.text + "}"


func _add_label_text(label : Label) -> String :
	return label.text + " & "


func set_column_spans(grid : GridContainer) :
	var grid_item_index := 0
	var grid_item_count := grid.get_child_count()
	var grid_children := grid.get_children()
	column_spans.clear()
	for x in grid_item_count / grid.columns :
		# Create 1 array entry per column
		while grid_item_index < grid.columns :
			var col_span : int = grid_children[grid_item_index].get_child_count()
			if col_span == 0 : col_span = 1
			column_spans.append(col_span)
			grid_item_index += 1
		print(column_spans)
		var array_index := 0
		# Replace appropriate array entry if col_span is larger
		while grid_item_index < grid_item_count :
			var col_span = grid_children[grid_item_index].get_child_count()
			if col_span > column_spans[array_index] :
				column_spans[array_index] = col_span
			array_index += 1
			if array_index == grid.columns : array_index = 0
			grid_item_index += 1
	for num in column_spans :
		latex_col_count += num


func _get_column_span(item_index : int, grid : GridContainer) -> int :
	return column_spans[_get_col_num(item_index, grid)]


func _get_col_num(item_index : int, grid : GridContainer) -> int :
	return (item_index + grid.columns) % grid.columns
