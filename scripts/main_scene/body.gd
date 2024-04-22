## Script of a parent node
## Used for signalling and call-downs

extends HBoxContainer

## Connects new parser to signal
func _connect_parser(parser : Parser) :
# warning-ignore:return_value_discarded
	parser.connect("tree_grown", self, "_on_tree_grown")

## Signalled when V.gloss_tree is complete
func _on_tree_grown() :
	activate_buttons()
	generate_formatting_rows()

## Set buttons active after file has been loaded
func activate_buttons() :
	$FileSettings/GeneratePreview.disabled = false
	$FileSettings/Buttons/Programs.set_default_software()

## Create the template formatting rows
func generate_formatting_rows() :
	$FileSettings/RowDefinitions.generate_format_rows()
	

## Start process of creating gloss preview
func _on_GeneratePreview_pressed():
	$Preview/ColorRect/PreviewLines.create_preview()
