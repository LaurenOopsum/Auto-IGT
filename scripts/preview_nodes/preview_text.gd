## Displays the preview text and holds preview children

class_name PreviewText
extends Label

var level : int

func format(template) :
	if template[4] : text = "'" + text + "'"
	if template[2] && template [3] : 
		change_font("res://dynamic_fonts/fonts/arialbi.ttf")
	elif template [2] :
		change_font("res://dynamic_fonts/fonts/ariali.ttf")
	elif template [3] :
		change_font("res://dynamic_fonts/fonts/arialbd.ttf")
	else : change_font("res://dynamic_fonts/fonts/arial.ttf")

func change_font(new_font : String) :
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load(new_font)
	dynamic_font.size = 16
	add_font_override("font", dynamic_font)
