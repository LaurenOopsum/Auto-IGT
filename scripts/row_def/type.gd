## DropDown that displays available row options
## Generated from the attributes

extends DropDown


func add_option(att_type : String) :
	var popup := get_popup()
	popup.add_item(att_type)

## Triggered when signal received from change of Level DropDown
func _on_level_changed(level : int):
#	print("_on_level_changed")
	var popup := get_popup()
	popup.clear()
#	print(C.TYPE_NAMES[level])
	if V.level_attributes.has(C.TYPE_NAMES[level]) :
		for line_def in V.level_attributes[C.TYPE_NAMES[level]] :
			add_option(line_def)
	if popup.get_item_count() > 0 :
		text = popup.get_item_text(0)


func set_default_value(string : String) :
	var popup := get_popup()
	for x in popup.get_item_count() :
		var popup_text := popup.get_item_text(x)
		if string in popup_text :
			text = popup_text
			return
