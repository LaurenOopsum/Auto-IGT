## Global variables used by the tool

extends Node

var file_type := ".flextext"
var software : String

var preset_format : int = C.PRESET.MORPH3

var gloss_tree : GlossTree

var start = 1 # start and end are untyped because different
var end       # programs identify the elements in different ways
var line_count := 3
var wrap_count := 1 # For wrapping long glosses, not yet supported

var level_attributes : Dictionary


