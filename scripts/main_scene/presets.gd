## DropDown for selecting preset gloss templates

extends DropDown

signal reset_preset() # sends signal to change template rows

## Change displayed template rows when preset is changed
## but only if a file has already been selected
func _on_option_selected(idx : int) :
#	var pop_up := get_popup()
	text = C.PRESET_NAMES[idx]
	V.preset_format = idx
	if V.gloss_tree && idx != C.PRESET.CUSTOM :
		emit_signal("reset_preset")

## Sets the chosen option to "Custom" when preset values are modified
func _on_RowTotal_text_changed(new_text : String) :
	if new_text != "" :
		_on_option_selected(C.PRESET.CUSTOM)
