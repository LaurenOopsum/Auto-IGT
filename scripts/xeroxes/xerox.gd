## Base class for Resource scripts that copy IGT to clipboard

class_name Xerox
extends GDScript



var phrase : GlossNode
var rows_data : Array


func copy(phrase_node : GlossNode, data : Array) :
	phrase = phrase_node
	rows_data = data
	clipboard_copy()


## Overwrite this function in descendent Xeroxes
func clipboard_copy() : pass
