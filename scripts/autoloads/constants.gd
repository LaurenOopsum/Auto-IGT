extends Node

enum TYPE {PARAGRAPH, PHRASE, WORD, MORPH}
enum PRESET {MORPH3, MORPH4, WORD3, WORD4, CUSTOM}
enum FILE_TYPE {FLEXTEXT}
enum PROGRAM {FLEX, ELAN}


const PRESET_NAMES := [
	"3 line morpheme gloss", 
	"4 line morpheme gloss", 
	"3 line word gloss", 
	"4 line word gloss", 
	"Custom gloss format"
	]

const FT_NAMES := [".flextext"]

const PROGRAM_NAMES := ["FLEx", "ELAN"]

# boolean value = option is active
const FT_PROGRAMS := {
	FT_NAMES[FILE_TYPE.FLEXTEXT] : [
		[PROGRAM_NAMES[PROGRAM.FLEX], true],
		[PROGRAM_NAMES[PROGRAM.ELAN], false]
	]
}

const FILTER_DESC := [
	{FT_NAMES[FILE_TYPE.FLEXTEXT] : "FlexText"}
]

const PRESET_TEMPLATES := [
	[[TYPE.MORPH, "txt"], [TYPE.MORPH, "gls"], [TYPE.PHRASE, "gls"]],
	[[TYPE.WORD, "txt"], [TYPE.MORPH, "txt"], [TYPE.MORPH, "gls"], [TYPE.PHRASE, "gls"]],
	[[TYPE.WORD, "txt"], [TYPE.WORD, "gls"], [TYPE.PHRASE, "gls"]],
	[[TYPE.PHRASE, "txt"], [TYPE.WORD, "txt"], [TYPE.WORD, "gls"], [TYPE.PHRASE, "gls"]]
]

const TYPE_NAMES := [
	"paragraph",
	"phrase",
	"word",
	"morph"
]
