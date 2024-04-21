extends FileDialog

signal connect_parser(parser) 

func open_file_dialog():
	var file_types : Dictionary = C.FILTER_DESC[C.FT_NAMES.find(V.file_type)]
	for extension in file_types :
		add_filter("*" + extension + " ; " + file_types[extension])
	show()

# Grab the file text and send it through to the correct parser
func _on_file_selected(path):
	var file_text := get_file_text(path)
	var parser := get_parser(path)
	parser.run(file_text)


func get_file_text(file_path : String) -> String :
	var selected_file := File.new()
# warning-ignore:return_value_discarded
	selected_file.open(file_path, File.READ)
	var file_text := selected_file.get_as_text()
	selected_file.close()
	return file_text


func get_parser(file_path : String) -> Parser :
	var file_type := file_path.right(file_path.rfind("."))
	var new_parser : Parser
	match file_type :
		".flextext" : new_parser = FlextextParser.new()
	emit_signal("connect_parser", new_parser)
	return new_parser
