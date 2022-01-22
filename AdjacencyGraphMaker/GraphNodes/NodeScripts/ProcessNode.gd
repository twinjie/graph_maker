extends Node2D

onready var radius := 20.0
onready var label = $Label
onready var process_index: int
onready var graph_node
onready var selected := false setget selected_update

func _ready() -> void:
	self.add_to_group("process")
	Signals.connect("renumber_processes", self, "_renumber_process")
	Signals.connect("button_pressed", self, "_deselect")
	$Area2D.connect("input_event", self, "_on_Area2D_input_event")
	$Area2D/CollisionShape2D.shape.radius = radius


func _deselect(state: int, btn: Node) -> void:
	selected = false
	update()


func selected_update(state: bool) -> void:
	selected = state
	update()


func init(process_num: int, graphNode: Node) -> void:
	graph_node = graphNode
	process_index = process_num
	if process_index > 9:
		label.rect_position.x = -11
	label.text = "P" + String(process_num)
	
	
func _remove_process() -> void:
	Signals.emit_signal("process_removed", self)
	if(Settings.auto_renumber):
		Signals.emit_signal("renumber_processes", process_index)
	self.queue_free()
		

func _renumber_process(num: int) -> void:
	if int(label.text[1]) > num:
		process_index -= 1
		if process_index > 9:
			label.rect_position.x = -11
		else:
			label.rect_position.x = -8
		label.text = "P" + String(process_index)


func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, 0, 360, 512, Color.black, 1)
	if selected:
		draw_circle(Vector2.ZERO, radius, Color(0.37, 0.62, 0.63, 0.5))
	
	
func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		if graph_node.button_state == 0: # default (no button toggled)
			selected_update(not selected)
		elif graph_node.button_state == 4: # Add connection
			selected_update(not selected)
			Signals.emit_signal("node_connection", event.position, self)
		elif graph_node.button_state == 5: # if delete node is toggled
			_remove_process()
		else:
			selected_update(false)
	
#	get_tree().set_input_as_handled()
		
