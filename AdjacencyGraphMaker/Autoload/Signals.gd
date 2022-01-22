extends Node

signal button_pressed(button_num, button)
signal clear_graph()

signal display_prompt(string, state)

signal process_added(node)
signal resource_added(node)

signal renumber_processes(num)
signal renumber_resources(num)

signal node_connection(pos, node)
signal update_matrix(size)

signal set_resource_units(amount)
signal process_removed(node)
signal resource_removed(node)
signal connection_added(node1, node2, connection)
signal connection_removed(node)
signal remove_connection_by_default(node)

signal write_to_file(string)

