## Holds constants for reference and functions to grab the correct one

extends Node

enum LANG {ENGLISH, SPANISH}

## Basic int references to settings and options
enum TYPE {PARAGRAPH, PHRASE, WORD, MORPH, ITEM, IGT}
enum PRESET {MORPH3, MORPH4, WORD3, WORD4, CUSTOM}

enum FILE_TYPE {FLEXTEXT}
enum PROGRAM {FLEX, ELAN}

enum MARKUP {LATEX, QUARTO_STATIC, QUARTO_DYNAMIC}
enum BLOCK {CODE_OPEN, CODE_CLOSE, ROW_OPEN, ROW_CLOSE, CELL_OPEN, CELL_CLOSE, MULTICOL_OPEN, MULTICOL_MID, MULTICOL_CLOSE, SEPARATOR, ITALIC_OPEN, ITALIC_CLOSE, BOLD_OPEN, BOLD_CLOSE}


## Names of the preset templates
const PRESET_NAMES := [
	"3_L_MORPH", 
	"4_L_MORPH", 
	"3_L_WORD", 
	"4_L_WORD", 
	"CUSTOM_G"
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


const MARKUP_TEXT := [
	[ # LaTeX
		"\\begin{tabular}{ ",
		"\\end{tabular}",
		"\t",
		" \\\\\n",
		"",
		"",
		"\\multicolumn{",
		"}{ l }{",
		"}",
		" & ",
		"\\textit{",
		"}",
		"\\textbf{",
		"}"
	],
	[ # Quarto static HTML
		"```{=html}\n\n<head>\n\t<style>\n\t\ttable, th, tr, td {\n\t\t\tborder-top: 1px solid transparent;\n\t\t\tborder-bottom: 1px solid transparent;\n\t\t}\n\t</style>\n</head>\n\n<table>\n\t<tbody>\n",
		"\t</tbody>\n</table>\n```",
		"\t\t<tr>\n",
		"\t\t</tr>\n",
		"\t\t\t<td>",
		"</td>\n",
		"\t\t\t<td colspan=",
		">",
		"</td>\n",
		"",
		"<i>",
		"</i>",
		"<b>",
		"</b>"
	],
	[
		"Quarto dynamic open",
		"Quarto dymanic close"
	]
]



## Loads a new instance of a RowDef template
func get_row_template() -> RowDef :
	return load("res://scenes/row_def.tscn").instance()

