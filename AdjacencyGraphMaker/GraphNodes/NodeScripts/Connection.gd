extends Node2D

onready var from: Vector2
onready var to: Vector2
onready var direction
onready var distance
onready var size = 20
onready var graph_node


func init(node :Node, start: Vector2, end:Vector2, graphNode: Node) -> void:
	self.add_to_group("connection")
	$Area2D.connect("input_event", self, "_on_Area2D_input_event")
	Signals.connect("remove_connection_by_default", self, "_remove_connection_by_default")
	graph_node = graphNode
	from = start
	to = end
	direction = (to - from).normalized()
	distance = (to - from).length()
	var polygonShape: PoolVector2Array
	
	# points projected +- 90 deg from start & end points to create rectangle
	polygonShape.append(from + direction.rotated(1.570796) * 10)
	polygonShape.append(from - direction.rotated(1.570796) * 10)
	polygonShape.append(to - direction.rotated(1.570796) * 10)
	polygonShape.append(to + direction.rotated(1.570796) * 10)
	$Area2D/CollisionPolygon2D.polygon = polygonShape
	

func _remove_connection() -> void:
	Signals.emit_signal("connection_removed", self)
	self.queue_free()
	

# If connecting node was removed	
func _remove_connection_by_default(node) -> void:
	if node == self:
		self.queue_free()


func _draw():
	draw_line(from, to, Color.black, 2)
	var a = to + direction.rotated(5*PI/6) * size
	var b = to + direction.rotated(7*PI/6) * size
	draw_line(to, a, Color.black, 2)
	draw_line(to, b, Color.black, 2)
	
	
func _on_Area2D_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
		if event is InputEventMouseButton && event.is_pressed() && event.button_index == BUTTON_LEFT:
			if graph_node.button_state == 6: # Remove connection toggled
				_remove_connection()
			get_tree().set_input_as_handled()
