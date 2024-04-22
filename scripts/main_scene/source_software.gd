## DropDown for selecting the program that produced the file

extends DropDown

## Populates menu with list of supported programs
func set_default_software() :
	disabled = false
	var pop_up := get_popup()
	pop_up.clear()
	var idx := 0
	var text_set := false
	for program in C.FT_PROGRAMS[V.file_type] :
		pop_up.add_item(program[0])
		pop_up.set_item_disabled(idx, !program[1])
		if !text_set && program[1] :
			text = pop_up.get_item_text(idx)
			V.software = text
			text_set = true
		idx += 1

## Sets global value
func _on_option_selected(idx : int) :
	var pop_up := get_popup()
	var id := pop_up.get_item_index(idx)
	text = pop_up.get_item_text(id)
	V.software = text
