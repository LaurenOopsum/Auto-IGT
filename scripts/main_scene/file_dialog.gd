## Reads a file from the user's system into the correct parser

extends FileDialog

signal connect_parser(parser) # sends signal to body.gd


func open_file_dialog():
	_set_filters()
	show()

## Sets the filters on the file selection dialog
## Only selected file format(s) can be opened
func _set_filters() :
	var file_types : Dictionary = C.FILTER_DESC[C.FT_NAMES.find(V.file_type)]
	for extension in file_types :
		add_filter("*" + extension + " ; " + file_types[extension])

## Triggered by signal when file is opened from dialog
## Runs the Parser
func _on_file_selected(path):
	var file_text := get_file_text(path)
	var parser := get_parser(path)
	parser.run(file_text)

## Returns text of the file as a String
func get_file_text(file_path : String) -> String :
	var selected_file := File.new()
# warning-ignore:return_value_discarded
	selected_file.open(file_path, File.READ)
	var file_text := selected_file.get_as_text()
	selected_file.close()
	return file_text

## Creates the correct Parser and returns it
func get_parser(file_path : String) -> Parser :
	var file_type := file_path.right(file_path.rfind("."))
	var new_parser : Parser
	match file_type :
		".flextext" : new_parser = FlextextParser.new()
	emit_signal("connect_parser", new_parser)
	return new_parser
