extends Node2D

onready var num_processes := 0
onready var num_resources := 0
onready var num_connections := 0

onready var process_nodes = $Graph/ProcessNodeHolder
onready var resource_nodes = $Graph/ResourceNodeHolder
onready var connections = $Graph/ConnectionHolder
onready var console = $Console
onready var matrix_node = $Matrix
onready var nodes = {}
onready var connection_ref = {}


func _ready() -> void:
	Signals.connect("process_added", self, "_process_added")
	Signals.connect("process_removed", self, "_process_removed")
	Signals.connect("resource_added", self, "_resource_added")
	Signals.connect("resource_removed", self, "_resource_removed")
	Signals.connect("connection_added", self, "_connection_added")
	Signals.connect("connection_removed", self, "_connection_removed")
	Signals.connect("clear_graph", self, "_clear_graph")
	Settings.connect("auto_renumber", self, "_auto_renumber")


func _renumber_resources() -> void:
	for i in nodes:
		if nodes[i].node_ID.is_in_group("resource"):
			nodes[i].node_index += 1

	
func _process_added(node) -> void:
	var index = num_processes
	num_processes += 1
	nodes[node] = {
		node_ID = node,
		node_name = node.label.text,
		node_index = index,
		has_connections = false,
		connections = [],
		connection_nodes = []
	}
	_renumber_resources()
	Signals.emit_signal("update_matrix", num_processes + num_resources)


func _process_removed(node) -> void:
	num_processes -= 1
	_connection_removed(node)
	var index = nodes[node].node_index
	for i in nodes:
		if nodes[i].node_index > index:
			nodes[i].node_index -= 1
	nodes.erase(node)
	Signals.emit_signal("update_matrix", num_processes + num_resources)
	
	
func _resource_added(node) -> void:
	var index = num_processes + num_resources
	num_resources += 1
	nodes[node] = {
		node_ID = node,
		node_name = node.label.text,
		node_index = index,
		has_connections = false,
		connections = [],
		connection_nodes = []
	}
	Signals.emit_signal("update_matrix", num_resources + num_processes)

	
func _resource_removed(node) -> void:
	num_resources -= 1
	_connection_removed(node)
	var index = nodes[node].node_index
	for i in nodes:
		if nodes[i].node_index > index:
			nodes[i].node_index -= 1
	nodes.erase(node)
	Signals.emit_signal("update_matrix", num_processes + num_resources)

	
func _connection_added(node1, node2, connection) -> void:
	num_connections += 1
	connection_ref[connection] = {
		connection_node = connection,
		from_node = node1,
		to_node = node2
	}
	nodes[node1].has_connections = true
	nodes[node1].connections.append(node2)
	nodes[node1].connection_nodes.append(connection)
	Signals.emit_signal("update_matrix", num_processes + num_resources)
	

func _connection_removed(node) -> void:
	if(node.is_in_group("connection")): # just deleting connection
		var from_node = connection_ref[node].from_node
		var to_node = connection_ref[node].to_node
		nodes[from_node].connections.erase(to_node)
		nodes[from_node].connection_nodes.erase(node)
		if(nodes[from_node].connections.size() == 0):
			nodes[from_node].has_connections = false
		connection_ref.erase(node)
		Signals.emit_signal("update_matrix", num_processes + num_resources)

	else:  # node is a process or resource, check if connection(s) exist
		var connects = []
		## Identify connection that need to be deleted
		for i in connection_ref:
			var from_node = connection_ref[i].from_node
			var to_node = connection_ref[i].to_node
			if (node == from_node || node == to_node):
				connects.append(connection_ref[i].connection_node)
		## Search through each connection and delete the relevant connenections
		## and update data in 'from' nodes in nodes dictionary
		for i in connects.size():
			var from_node = connection_ref[connects[i]].from_node
			var to_node = connection_ref[connects[i]].to_node
			nodes[from_node].connection_nodes.erase(connects[i])
			nodes[from_node].connections.erase(to_node)
			if(nodes[from_node].connections.size() == 0):
				nodes[from_node].has_connections = false
			Signals.emit_signal(
				"remove_connection_by_default", 
				connection_ref[connects[i]].connection_node
			)
			connection_ref.erase(connects[i])
			
			
func _clear_graph() -> void:
	# Remove nodes
	for process in process_nodes.get_children():
		process.queue_free()
	for resource in resource_nodes.get_children():
		resource.queue_free()
	for connection in connections.get_children():
		connection.queue_free()
		
	# Clear dictionaries and set node counts to 0
	nodes.clear()
	connection_ref.clear()
	num_processes = 0
	num_resources = 0
	num_connections = 0
	Signals.emit_signal("update_matrix", 0)
			
			
# Use a dictionary to represent settings because we have few values for now. Also, when you
# have many more settings, you can replace it with an object without having to refactor the code
# too much, as in GDScript, you can access a dictionary's keys like you would access an object's
# member variables.
func update_settings(settings: Dictionary) -> void:
	OS.window_fullscreen = settings.fullscreen
#	get_tree().set_screen_stretch(
#		SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, settings.resolution
#	)
	OS.set_window_size(settings.resolution)
	Settings.auto_renum(settings.auto_renum)
	Settings.set_label(settings.label_matrix)
#	$Graph.background.rect_size.x = get_viewport_rect().size.x * 0.5
#	$Matrix.background.rect_size.x = get_viewport_rect().size.x * 0.5
#	$Matrix.background.rect_position.x = get_viewport_rect().size.x * 0.5


func _auto_renumber() -> void:
	for i in nodes:
		if nodes[i].node_ID.is_in_group("process"):
			var node = nodes[i].node_ID
			node.process_index = nodes[i].node_index
			if node.process_index > 9:
				node.label.rect_position.x = -11
			node.label.text = "P" + String(node.process_index)
		elif nodes[i].node_ID.is_in_group("resource"):
			var node = nodes[i].node_ID
			node.resource_index = nodes[i].node_index - num_processes
			if node.resource_index > 9:
				node.label.rect_position.x = -11
			node.label.text = "R" + String(node.resource_index)


# Call the `update_settings` function when the user presses the button
func _on_Menu_apply_button_pressed(settings):
	update_settings(settings)
