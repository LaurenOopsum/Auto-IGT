## A basic drop-down menu that sets its text value to the item selected

class_name DropDown
extends MenuButton

## Connects embedded pop-up to function
func _ready() :
# warning-ignore:return_value_discarded
	get_popup().connect("id_pressed", self, "_on_option_selected")

## Sets MenuButton text to the text of the selected option
func _on_option_selected(idx : int) :
	var pop_up := get_popup()
	var id := pop_up.get_item_index(idx)
	text = pop_up.get_item_text(id)
	select_action(idx)

## Overwrite in descendent classes
func select_action(_idx : int) : pass
