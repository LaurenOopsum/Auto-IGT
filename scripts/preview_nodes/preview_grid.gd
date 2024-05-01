## A grid that holds 

class_name PreviewGrid
extends GridContainer

var level : int
var rows := []


func _adjust_row_length(labels : Array) -> Array :
	if get_child_count() > 0 :
		var diff := labels.size() - columns
		# fill out the rest of the previous row
		# increase column count
		if diff > 0 : 
			for x in diff :
				var filler := Control.new()
				add_child(filler)
			columns = labels.size()
		# fill out the rest of the array to a full row
		elif diff < 0 :
			for x in diff :
				var filler := Control.new()
				labels.append(filler)
	elif labels.size() > 0 : columns = labels.size()
	return labels
