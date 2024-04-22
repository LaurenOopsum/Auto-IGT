## LineEdit that holds the count of lines when wrapping

extends LineEdit

## Changes incompatible value to something that makes sense
## when the checkbox is toggled
func _on_Wrapping_toggled(checked : bool) :
	if checked && text == "1" :
		text = "2"
		V.wrap_count = 2
	elif !checked :
		text = "1"
		V.wrap_count = 1
