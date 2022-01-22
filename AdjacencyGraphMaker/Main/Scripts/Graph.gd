extends Node2D

enum toggles {DEFAULT, ADD_PROCESS, ADD_RESOURCE, SET_RESOURCES, ADD_CONNECTION,
				REMOVE_NODE, REMOVE_CONNECTION}


export var process_node: PackedScene
export var resource_node: PackedScene
export var connection: PackedScene
				
onready var button_state = toggles.DEFAULT
onready var console = get_parent().get_node("Console")
onready var parent = get_parent()
onready var process_container = $ProcessNodeHolder
onready var resource_container = $ResourceNodeHolder
onready var connection_container = $ConnectionHolder
onready var buttons = $CanvasLayer/Buttons
onready var background = $GraphBackground

var first_position := true
var pos1: Vector2
var pos2: Vector2
var start_node: Node
var end_node: Node


func _ready() -> void:
	Signals.connect("button_pressed", self, "_on_button_pressed")
	Signals.connect("node_connection", self, "_add_connection")
	
	
#func _process(delta) -> void:
#	background.rect_size.x = get_viewport_rect().size.x * 0.5
	

func _on_button_pressed(btn_num: int, btn: Node) -> void:
	if !btn.is_pressed():
		button_state = toggles.DEFAULT
		Signals.emit_signal("display_prompt", "", 0)
	else:
		match[btn_num]:
			[toggles.ADD_PROCESS]:
				button_state = toggles.ADD_PROCESS
				Signals.emit_signal("display_prompt", "Click anywhere in the white space to add a process node", 0)
			[toggles.ADD_RESOURCE]:
				button_state = toggles.ADD_RESOURCE
				Signals.emit_signal("display_prompt", "Click anywhere in the white space to add a resource node", 0)
			[toggles.SET_RESOURCES]:
				button_state = toggles.SET_RESOURCES
				Signals.emit_signal("display_prompt", "Select resource(s) and enter resource amount (1-4)", 1)
			[toggles.ADD_CONNECTION]:
				button_state = toggles.ADD_CONNECTION
				Signals.emit_signal("display_prompt", "Select a start node, followed by an end node to create a connection", 0)
			[toggles.REMOVE_NODE]:
				button_state = toggles.REMOVE_NODE
				Signals.emit_signal("display_prompt", "Click on a process node or resource node to delete it", 0)
			[toggles.REMOVE_CONNECTION]:
				button_state = toggles.REMOVE_CONNECTION
				Signals.emit_signal("display_prompt", "Click on a connection to delete it", 0)
				
				
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		var pos = event.position
#		print("Position = ", pos)
		var bounds = background.rect_size
#		if !(pos.x > 620) && !(pos.x < 20) && !(pos.y > 460) && !(pos.y < 40):
		if !(pos.x > bounds.x - 20) && !(pos.x < 20) && !(pos.y > bounds.y - 20) && !(pos.y < 40):
			match[button_state]:
				[toggles.ADD_PROCESS]:
					_add_process(pos)
					first_position = true
				[toggles.ADD_RESOURCE]:
					_add_resource(pos)
					first_position = true
				[toggles.SET_RESOURCES]:
					first_position = true
				[toggles.ADD_CONNECTION]:
					pass # Handled by process/resource node's script
				[toggles.REMOVE_NODE]:
					first_position = true
				[toggles.REMOVE_CONNECTION]:
					first_position = true
				_: # Default case
					first_position = true
				
			
func _add_process(pos: Vector2) -> void:
	var new_process = process_node.instance()
	process_container.add_child(new_process)
	new_process.init(parent.num_processes, self)
	new_process.position = pos
	Signals.emit_signal("process_added", new_process)
	
	
func _add_resource(pos: Vector2) -> void:
	var new_resource = resource_node.instance()
	resource_container.add_child(new_resource)
	new_resource.init(1, parent.num_resources, self, console)
	new_resource.position = pos
	Signals.emit_signal("resource_added", new_resource)
	

func _add_connection(pos: Vector2, node: Node) -> void:
	if first_position:
		pos1 = pos
		start_node = node
		first_position = false
	else:
		if node == start_node:
			first_position = true
			start_node.selected_update(false)
		else:
			pos2 = pos
			end_node = node
			var new_connection = connection.instance()
			connection_container.add_child(new_connection)
			new_connection.init(new_connection, pos1, pos2, self)
			Signals.emit_signal("connection_added", start_node, end_node, new_connection)
			first_position = true
			start_node.selected_update(false)
			end_node.selected_update(false)
			
			
func get_available_resources() -> Array:
	var resources = []
	if $ResourceNodeHolder.get_child_count() == 0:
		return resources
	
	for i in $ResourceNodeHolder.get_children():
		resources.append(i.num_units)
		
	return resources
