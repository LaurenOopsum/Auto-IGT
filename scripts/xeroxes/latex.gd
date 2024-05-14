
class_name LatexXerox
extends Xerox


func define_columns(col_count : int) -> String :
	var latext := ""
	for x in col_count :
		latext += "l "
	return latext + "}\n"


func get_constant() -> int :
	return C.MARKUP.LATEX
