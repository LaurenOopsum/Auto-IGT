## DropDown for selecting a file type
## Automatically updates global variable

extends DropDown


func _on_option_selected(idx : int) :
	var pop_up := get_popup()
	var id := pop_up.get_item_index(idx)
	text = pop_up.get_item_text(id)
	V.file_type = text
