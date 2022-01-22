extends Node


export var auto_renumber := true
export var label_matrix := true
signal auto_renumber
signal matrix_update


func auto_renum(value: bool) -> void:
	auto_renumber = value
	if auto_renumber: # was just set true, renumber all nodes
		emit_signal("auto_renumber")


func set_label(value: bool) -> void:
	label_matrix = value
	emit_signal("matrix_update")
