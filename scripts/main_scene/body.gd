extends HBoxContainer


func _connect_parser(parser : Parser) :
# warning-ignore:return_value_discarded
	parser.connect("tree_grown", self, "_on_tree_grown")


func _on_tree_grown() :
	activate_buttons()
	generate_formatting_rows()


func activate_buttons() :
	$FileSettings/GeneratePreview.disabled = false
	$FileSettings/Buttons/Programs.set_default_software()


func generate_formatting_rows() :
	$FileSettings/RowDefinitions.generate_format_rows()
	


func _on_GeneratePreview_pressed():
	$Preview/ColorRect/PreviewGrid.create_preview()
