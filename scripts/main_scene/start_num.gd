extends LineEdit


func _on_text_changed(new_text : String) :
	if new_text != "" :
		V.start = to_type(new_text)


func to_type(text : String) :
	var software := C.PROGRAM_NAMES.find(V.software)
	match software :
		C.PROGRAM.FLEX : return int(text)
		C.PROGRAM.ELAN : return text # change to time
