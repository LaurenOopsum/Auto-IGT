## Script that stores the starting phrase

extends LineEdit

## Changes the global variable
func _on_text_changed(new_text : String) :
	if new_text != "" :
		V.start = to_type(new_text)

## Converts the String value into the correct type
func to_type(text : String) :
	var software := C.PROGRAM_NAMES.find(V.software)
	match software :
		C.PROGRAM.FLEX : return int(text)
		C.PROGRAM.ELAN : return text # change to time
