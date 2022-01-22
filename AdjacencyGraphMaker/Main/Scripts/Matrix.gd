extends Node2D

onready var parent = get_parent()
onready var container = $CenterContainer
onready var matrix_output = $MatrixBackground/Text
onready var background = $MatrixBackground
onready var prev_process_count := 0
onready var prev_resource_count := 0
onready var prev_connection_count := 0
onready var matrix = []
onready var matrix_labels = []
onready var string: String
onready var size: int

func _ready() -> void:
	Signals.connect("update_matrix", self, "_update_matrix")
	Settings.connect("matrix_update", self, "update_matrix")


#func _process(delta) -> void:
#	background.rect_size.x = get_viewport_rect().size.x * 0.5
#	background.rect_position.x = get_viewport_rect().size.x * 0.5
		
func _update_matrix(current_size: int) -> void:
	size = current_size
	update_matrix()


func update_matrix() -> void:
	# Redraw first
	matrix.clear()
	matrix_labels.clear()
	for row in size:
		matrix.append([])
		for col in size:
			if col == row:
				matrix[row].append(1)
			else:
				matrix[row].append(0)
	# Update Values
	for i in parent.nodes:
		if parent.nodes[i].has_connections:			
			for j in parent.nodes[i].connections:
				var x = parent.nodes[i].node_index
				var y = parent.nodes[j].node_index
				matrix[x][y] = 1

	# Output matrix
	string = ""
	for i in size:
		for j in size:
			string += String(matrix[i][j])
			if j < size - 1:
				string +=  ","
		string += "\n"
#	matrix_output.rect_size = Vector2(size, size) * 40
	
	if Settings.label_matrix:
		## Super not efficient ordering of labels
		var count = 0
		while count < size:
			for i in parent.nodes:
				if parent.nodes[i].node_index == count:
					var node = parent.nodes[i].node_ID
					matrix_labels.append(node.label.text)
					count += 1
				if count == size:
					break
		var labelled_string = ""
		# Print row of labels
		for i in size:
			if i == 0:
				labelled_string += "     "
				if size > 10:
					labelled_string += "  "
			labelled_string += "[b]" + String(matrix_labels[i]) + "[/b]  "
			if size > 10:
				if i < 10:
				 labelled_string += "  "
			
#			labelled_string += String(matrix_labels[i]) + "  "
		labelled_string += "\n"
		for i in size:
			labelled_string += "[b]" + String(matrix_labels[i]) + "[/b]  "
			if size > 10:
				if i < 10:
					labelled_string += "  "
			for j in size:
				labelled_string += String(matrix[i][j])
				if j < size - 1:
					labelled_string += ",    "
				if size > 10:
					labelled_string += "  "
			labelled_string += "\n"
		
		matrix_output.bbcode_enabled = true	
#		matrix_output.text = labelled_string
		matrix_output.bbcode_text = labelled_string
#		matrix_output.append_bbcode(labelled_string)
	
	else:
		matrix_output.text = string
		
		
