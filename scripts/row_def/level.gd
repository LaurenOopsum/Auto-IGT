## Row template selection of word/morph/etc. level

extends DropDown

signal level_changed(level)

## Signals to Type DropDown to change options
func _on_option_selected(idx : int) :
	var pop_up := get_popup()
	text = pop_up.get_item_text(idx)
	emit_signal("level_changed", idx)
