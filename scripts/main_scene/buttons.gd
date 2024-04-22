## Opens the file selection dialog when the button is pressed

extends HBoxContainer

signal open_file_dialog() 


func _on_SelectFile_pressed():
	emit_signal("open_file_dialog")



