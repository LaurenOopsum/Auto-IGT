extends DropDown

signal level_changed(level)

func _on_option_selected(idx : int) :
	var pop_up := get_popup()
	text = pop_up.get_item_text(idx)
	emit_signal("level_changed", idx)
