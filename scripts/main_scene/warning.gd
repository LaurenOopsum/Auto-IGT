extends TextureRect




func _on_show_warning(warning_type : int):
	show()
	match warning_type :
		C.MARKUP.QUARTO_STATIC : hint_tooltip = "QUARTO_STATIC_WARNING"


func _on_hide_warning():
	hide()
