extends Node2D

onready var square: Rect2
onready var _size = Vector2(40.0, 40.0)
onready var num_units: int
onready var label = $Label
onready var units_label = $UnitsLabel
onready var resource_index: int
onready var graph_node
onready var selected := false setget selected_update
onready var console

func _ready() -> void:
	self.add_to_group("resource")
	Signals.connect("button_pressed", self, "_deselect")
	Signals.connect("renumber_resources", self, "_renumber_resource")
	Signals.connect("set_resource_units", self, "_set_resource_units")
	$Area2D.connect("input_event", self, "_on_Area2D_input_event")
	$Area2D/CollisionShape2D.shape.extents = _size / 2
#	units_label.text.color


func _deselect(state: int, btn: Node) -> void:
	selected = false
	update()
	
	
func selected_update(state: bool) -> void:
	selected = state
	update()


func init(numUnits: int, resourceIndex: int, graphNode: Node, consoleNode: Node) -> void:
	graph_node = graphNode
	console = consoleNode
	num_units = numUnits
	resource_index = resourceIndex
	square.position = Vector2(-20,-20)
	square.size = _size
	if resource_index > 9:
		label.rect_position.x = -11
	label.text = "R" + String(resource_index)

func _renumber_resource(num: int) -> void:
	if resource_index > num:
		resource_index -= 1
		label.text = "R" + String(resource_index)


func _set_resource_units(num) -> void:
	if selected:
		if num < 1: #minimum of 1 resource
			num = 1
		num_units = num
		units_label.text = ""
		if num_units > 4:
			units_label.text = str(num)
		update()


func _remove_resource() -> void:
	Signals.emit_signal("resource_removed", self)
	if(Settings.auto_renumber):
		Signals.emit_signal("renumber_resources", resource_index)
	self.queue_free()


func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		if graph_node.button_state == 0: # default (no button toggled)
			selected_update(not selected)
		elif graph_node.button_state == 3: # Set resources
			selected_update(not selected)
		elif graph_node.button_state == 4: # Add connection
			selected_update(not selected)
			Signals.emit_signal("node_connection", event.position, self)
		elif graph_node.button_state == 5: # if delete node is toggled
			_remove_resource()
		else:
			selected_update(false)


func _draw() -> void:
	draw_rect(square, Color.black, false)
	if selected:
		draw_rect(square, Color(0.37, 0.62, 0.63, 0.5), true)
	
	#Draw resource circles if 4 or less
	if num_units <= 4:
		for i in num_units: 
			match [i]:
				[0]:
					draw_circle(Vector2(-13,-13), 5, Color.darkred)
				[1]:
					draw_circle(Vector2(13,-13), 5, Color.darkred)
				[2]:
					draw_circle(Vector2(-13,13), 5, Color.darkred)
				_: # Max of 4
					draw_circle(Vector2(13,13), 5, Color.darkred)
