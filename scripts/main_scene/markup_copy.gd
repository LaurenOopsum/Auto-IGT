extends DropDown

enum MARKUP {LATEX, QUARTO_ST, QUARTO_DY}

signal req_phrase()

var phrase : GlossNode


func _ready() :
	var pop_up := get_popup()
	if !pop_up.is_connected("id_pressed", self, "_on_option_selected") :
# warning-ignore:return_value_discarded
		pop_up.connect("id_pressed", self, "_on_option_selected")
	pop_up.set_current_index(0)
	


## Sets MenuButton text to the text of the selected option
func _on_option_selected(idx : int) :
	var pop_up := get_popup()
	var id := pop_up.get_item_index(idx)
	text = pop_up.get_item_text(id)
	request_phrase()


func request_phrase() : emit_signal("req_phrase")


func copy_igt() :
	var pop_up := get_popup()
	match pop_up.get_current_index() :
		MARKUP.LATEX : copy_latex()
		MARKUP.QUARTO_ST : copy_quarto_static()
		MARKUP.QUARTO_DY : copy_quarto_dynamic()


func copy_latex() : print("copy LaTeX")

func copy_quarto_static() : pass

func copy_quarto_dynamic() : pass


func _on_phrase_received(phrase_node : GlossNode) :
	print("phrase received")
	phrase = phrase_node
	copy_igt()
