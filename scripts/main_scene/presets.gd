extends DropDown

signal reset_preset()


func _on_option_selected(idx : int) :
#	var pop_up := get_popup()
	text = C.PRESET_NAMES[idx]
	V.preset_format = idx
	if V.gloss_tree && idx != C.PRESET.CUSTOM :
		emit_signal("reset_preset")


func _on_RowTotal_text_changed(new_text : String) :
	if new_text != "" :
		_on_option_selected(C.PRESET.CUSTOM)
