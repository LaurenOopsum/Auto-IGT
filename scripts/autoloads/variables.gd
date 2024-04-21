extends Node

var file_type := ".flextext"
var software : String

var preset_format : int = C.PRESET.MORPH3

var gloss_tree : GlossTree

var start = 1
var end
var line_count := 3
var wrap_count := 1

var level_attributes : Dictionary
