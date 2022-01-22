extends HBoxContainer


onready var add_process := $AddProcess
onready var add_resource := $AddResource
onready var set_resource_units := $SetResourceUnits
onready var add_connection := $AddConnection
onready var remove_node := $RemoveNode
onready var remove_connection := $RemoveConnection
onready var clear_graph := $Clear
onready var _buttons := get_children()


func _ready() -> void:
	add_process.connect("pressed", self, "_add_process")
	add_resource.connect("pressed", self, "_add_resource")
	set_resource_units.connect("pressed", self, "_set_resource_units")
	add_connection.connect("pressed", self, "_add_connection")
	remove_node.connect("pressed", self, "_remove_node")
	remove_connection.connect("pressed", self, "_remove_connection")
	clear_graph.connect("pressed", self, "_clear_graph")
	

func _add_process() -> void:
	Signals.emit_signal("button_pressed", 1, add_process)
	_unpress_other_buttons(add_process)
	
func _add_resource() -> void:
	Signals.emit_signal("button_pressed", 2, add_resource)
	_unpress_other_buttons(add_resource)
	
func _set_resource_units() -> void:
	Signals.emit_signal("button_pressed", 3, set_resource_units)
	_unpress_other_buttons(set_resource_units)
	
func _add_connection() -> void:
	Signals.emit_signal("button_pressed", 4, add_connection)
	_unpress_other_buttons(add_connection)
	
func _remove_node() -> void:
	Signals.emit_signal("button_pressed", 5, remove_node)
	_unpress_other_buttons(remove_node)
	
func _remove_connection() -> void:
	Signals.emit_signal("button_pressed", 6, remove_connection)
	_unpress_other_buttons(remove_connection)
	
func _clear_graph() -> void:
	Signals.emit_signal("clear_graph")

func _unpress_other_buttons(button):
	for i in _buttons:
		if i != button:
			i.pressed = false
