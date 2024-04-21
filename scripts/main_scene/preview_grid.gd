extends VBoxContainer

var gloss_grid : GridContainer


func create_preview(rows_data : Array) :
	if V.end : print("Multiple phrases not yet supported")
	else : 
		for template in rows_data :
			if [C.TYPE_NAMES[C.TYPE.PARAGRAPH], C.TYPE_NAMES[C.TYPE.PHRASE]].has(template[0].to_lower()) : 
				print("No grid preview line")
			else : print("Grid preview line")

## Get array of rows data
## If any are not "phrase" or "paragraph"
	## Get word count (1 time)
	## Create grid (1 time ish)
	## Find associated word
	## Add to grid
