
class_name SystemFileNavigator
extends Node

signal file_selected(xml_array)


var get_file_callback := JavaScript.create_callback(self, "get_file")
var window : JavaScriptObject


func _ready() :
	window = JavaScript.get_interface("window")
	window.getFlextext(get_file_callback)


func open_file_selector() :
	window.input.click()


func get_file(args) :
	var file_string : String = args[0]
	file_string = file_string.replace("<", "*<")
	file_string = file_string.replace(">", ">*")
	var packed_string_array := file_string.split("*", false)
	var string_array : Array
	for item in packed_string_array :
		if item.contains("\r\n") : pass
		else : string_array.append(item)
	emit_signal("file_selected", string_array)
#	file_selected.emit(string_array)
	
