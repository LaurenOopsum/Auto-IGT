
class_name GlossTree
extends Node

var gloss_title : String


func print_gloss_tree() :
	pass
	for child in get_children() :
		print_node_info(child)
		print_family_tree(child)


func print_family_tree(parent : GlossNode) :
	if parent.get_child_count() > 0 :
		for child in parent.get_children() :
			print_node_info(child)
			print_family_tree(child)


func print_node_info(node : GlossNode) :
	print(node.node_type + " - " + str(node.get_child_count()))
