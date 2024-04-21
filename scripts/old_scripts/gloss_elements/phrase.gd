# A node that represents an XML phrase element

class_name Phrase
extends Node


func get_phrase_rows() -> Array :
	var original_phrase := get_phrase_row("txt")
	var word_row := get_word_row("txt")
	var morpheme_row := get_morpheme_row("txt")
	var cf_row := get_morpheme_row("cf")
	var m_gloss_row := get_morpheme_row("gls")
	var m_pos_row := get_morpheme_row("msa")
	var w_gloss_row := get_word_row("gls")
	var w_pos_row := get_word_row("pos") # this row isn't working right
	var free_translation := get_phrase_row("gls")
	#[String, Array[String], Array[Array[String]], ...]
	return [original_phrase, word_row, morpheme_row, cf_row, m_gloss_row, m_pos_row, w_gloss_row, w_pos_row, free_translation]


# Returns rows from the phrase level
func get_phrase_row(row_name : String) -> String :
	for child in get_children() :
		if child is XMLItem && child.type == row_name : return child.text
	return ""

# Returns rows from the word level
func get_word_row(row_name : String) -> Array :
	var word_row : Array
	for child in get_children() :
		if child is Word : word_row.append(child.get_word_row_text(row_name))
	return word_row

# Returns rows from the morpheme level
func get_morpheme_row(row_name : String) -> Array :
	var morpheme_row : Array
	for child in get_children() :
		if child is Word :
			morpheme_row.append(child.get_row_text_from_morpheme(row_name))
	return morpheme_row
