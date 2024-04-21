
class_name RowDef
extends HBoxContainer


func setup_row(row_num : int, line_array : Array) :
	$RowNum.text = str(row_num)
	if row_num == 1 && line_array[0] == C.TYPE.PHRASE : 
		$Italic.pressed = true
	if row_num == V.line_count : $Quotes.pressed = true
	$Level.text = $Level.get_popup().get_item_text(line_array[0])
	$Type._on_level_changed(C.TYPE_NAMES.find(line_array[0]))
	$Type.set_default_value(line_array[1])
	

func setup_blank_row(row_num : int) :
	$RowNum.text = str(row_num)


func get_settings() -> Array :
	return [$Level.text, $Type.text, $Italic.pressed, $Bold.pressed, $Quotes.pressed]
