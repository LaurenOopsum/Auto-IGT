extends LineEdit


func _on_Wrapping_toggled(checked : bool) :
	if checked && text == "1" :
		text = "2"
		V.wrap_count = 2
	elif !checked :
		text = "1"
		V.wrap_count = 1
