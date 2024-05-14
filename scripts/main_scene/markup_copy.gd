extends DropDown

signal show_warning(warning_type)
signal hide_warning()

var phrase : GlossNode
var rows_data : Array

var xerox : Xerox


func _ready() :
	var pop_up := get_popup()
	if !pop_up.is_connected("id_pressed", self, "_on_option_selected") :
# warning-ignore:return_value_discarded
		pop_up.connect("id_pressed", self, "_on_option_selected")
	pop_up.set_current_index(0)


## Sets MenuButton text to the text of the selected option
func _on_option_selected(idx : int) :
	var pop_up := get_popup()
	pop_up.set_current_index(idx)
	var id := pop_up.get_item_index(idx)
	text = pop_up.get_item_text(id)
	if phrase : copy_igt()
	if idx == C.MARKUP.QUARTO_STATIC :
		emit_signal("show_warning", idx)
	else : emit_signal("hide_warning")


func copy_igt() :
	var path = "res://scripts/xeroxes/"
	var pop_up := get_popup()
	match pop_up.get_current_index() :
		C.MARKUP.LATEX : xerox = load(path + "latex.gd").new()
		C.MARKUP.QUARTO_STATIC : xerox = load(path + "quarto_static.gd").new()
		C.MARKUP.QUARTO_DYNAMIC : pass
	run_xerox()


func run_xerox() : xerox.copy(phrase, rows_data)


func _on_phrase_received(phrase_node : GlossNode, rows : Array) :
	phrase = phrase_node
	rows_data = rows
	copy_igt()


func _on_CopyButton_pressed():
	if phrase && rows_data : copy_igt()
