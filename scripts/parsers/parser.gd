## Basic class for various parsers

class_name Parser
extends Node

# warning-ignore:unused_signal
signal tree_grown()

var code_array : Array
var element_index := 0

var gloss_tree : GlossTree


func run(file_text : String) :
	create_string_array(file_text)
	grow_tree()


func create_string_array(_file_text : String) :
	pass


func grow_tree() :
	gloss_tree = GlossTree.new()


