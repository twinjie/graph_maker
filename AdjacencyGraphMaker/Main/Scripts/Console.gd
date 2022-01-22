extends Control

enum input_state {NONE, SET_RESOURCE_UNITS, GEN_FILE}

onready var prompt = $Prompt
onready var input_line = $UserInput
onready var background = $ConsoleBackground
onready var input_mode = input_state.NONE

var input_string := ""


func _ready() -> void:
	Signals.connect("display_prompt", self, "_display_prompt")



func _process(delta) -> void:
	background.rect_size.x = get_viewport_rect().size.x


func _display_prompt(string: String, state) -> void:
	input_mode = state
	prompt.text = string



func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		match [input_mode]:
			[input_state.NONE]:
				input_line.text = ""
			[input_state.SET_RESOURCE_UNITS]:
				input_string = input_line.text
				Signals.emit_signal("set_resource_units", int(input_string))
				input_line.text = ""
			[input_state.GEN_FILE]:
				input_string = input_line.text
				Signals.emit_signal("write_to_file", input_string)
				input_line.text = ""

