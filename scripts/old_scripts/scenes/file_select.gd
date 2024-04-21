extends VBoxContainer

signal igt_rows_created(rows_array)

var main_parser : FlextextParser

### Signal functions triggered by buttons ###

## Opens the file selection dialog
func _on_select_file_pressed():
	$FileNavigator.open_file_selector()

## Selects a file and generates an initial preview
func _on_file_selected(xml_array : Array):
	var sheet_nodes := xml_to_nodes(xml_array)
	add_child(sheet_nodes)
	var start_num : String = $Phrase/StartNum.text
	if start_num == "" : start_num = $Phrase/StartNum.placeholder_text
	print("START NUM: " + str(start_num))

	var example_rows := sheet_nodes.create_example_rows(start_num)
	emit_signal("igt_rows_created", example_rows)
#	igt_rows_created.emit(example_rows)


func xml_to_nodes(xml_array : Array) -> GlossTree:
#	$Selection/Path.text = path # display the selected filepath
	# Open IGT Parser
	main_parser = FlextextParser.new()
	return main_parser.parse_igt(xml_array)

