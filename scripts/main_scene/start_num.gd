## Script that stores the starting phrase

extends LineEdit

## Changes the global variable
func _on_text_changed(new_text : String) :
	if new_text != "" :
		V.start = int(new_text)
