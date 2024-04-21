extends CheckBox




func _on_WrapLines_text_changed(new_text : String) :
	if new_text != "" :
		if int(new_text) > 1 : pressed = true
		else : pressed = false
		V.wrap_count = int(new_text)
