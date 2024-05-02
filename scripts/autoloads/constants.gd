## Holds constants for reference and functions to grab the correct one

extends Node

## Basic int references to settings and options
enum TYPE {PARAGRAPH, PHRASE, WORD, MORPH, ITEM, IGT}
enum PRESET {MORPH3, MORPH4, WORD3, WORD4, CUSTOM}
enum FILE_TYPE {FLEXTEXT}
enum PROGRAM {FLEX, ELAN}
enum MARKUP {LATEX, QUARTO_ST, QUARTO_DY}

## Names of the different types of nodes
#const TYPE_NAMES := [
#	
#	"paragraph",
#	"phrase",
#	"word",
#	"morph",
#	"item"
#]

## Names of the preset templates
const PRESET_NAMES := [
	"3 line morpheme gloss", 
	"4 line morpheme gloss", 
	"3 line word gloss", 
	"4 line word gloss", 
	"Custom gloss format"
	]

## Supported file formats, represented as file extensions
const FT_NAMES := [".flextext"]

## Support programs
const PROGRAM_NAMES := ["FLEx", "ELAN"]

## Programs associated with each FILE_TYPE
# boolean value = option is active
const FT_PROGRAMS := {
	FT_NAMES[FILE_TYPE.FLEXTEXT] : [
		[PROGRAM_NAMES[PROGRAM.FLEX], true],
		[PROGRAM_NAMES[PROGRAM.ELAN], false]
	]
}

## Filters for file selection
const FILTER_DESC := [
	{FT_NAMES[FILE_TYPE.FLEXTEXT] : "FlexText"}
]

## Preset templates
# Need to remove the strings here and make them references
const PRESET_TEMPLATES := [
	[[TYPE.MORPH, "txt"], [TYPE.MORPH, "gls"], [TYPE.PHRASE, "gls"]],
	[[TYPE.WORD, "txt"], [TYPE.MORPH, "txt"], [TYPE.MORPH, "gls"], [TYPE.PHRASE, "gls"]],
	[[TYPE.WORD, "txt"], [TYPE.WORD, "gls"], [TYPE.PHRASE, "gls"]],
	[[TYPE.PHRASE, "txt"], [TYPE.WORD, "txt"], [TYPE.WORD, "gls"], [TYPE.PHRASE, "gls"]]
]


const OPEN_CLOSE := [
	[
		"\\begin{tabular}{ ",
		"\\end{tabular}"
	],
	[
		"Quarto static open",
		"Quarto static close"
	],
	[
		"Quarto dynamic open",
		"Quarto dymanic close"
	]
]


## Loads a new instance of a RowDef template
func get_row_template() -> RowDef :
	return load("res://scenes/row_def.tscn").instance()
