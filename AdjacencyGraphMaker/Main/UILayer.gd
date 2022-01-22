extends CanvasLayer

onready var main = get_parent()
onready var graph = get_parent().get_node("Graph")
onready var console = get_parent().get_node("Console")
onready var matrix = get_parent().get_node("Matrix")
onready var background = $ColorRect
onready var output = $ColorRect/Output
onready var version = "0.9"
onready var date = "05/02/2021"


func _ready() -> void:
	Signals.connect("write_to_file", self, "_write_file")


func _write_file(filepath) -> void:
	var file = File.new()
#	file.open("c:/users/chris/desktop/test.txt", File.WRITE)
	file.open(filepath, File.WRITE)
	if !file.is_open():
		console.prompt.text = "Unable to create file."
	else:
		var string = file_output_string()
		file.store_string(string)
		console.prompt.text = "File created."
		yield(get_tree().create_timer(1), "timeout")
		console.prompt.text = ""
	file.close()


func _on_Options_pressed():
	$Menu.visible = not $Menu.visible


func _on_AboutButton_pressed():
	background.visible = true
	var about_str = "[b]About:[/b]"
	about_str += "\n- This tool can be used to create a di-graph consisiting of process and resource nodes."\
	+ "\n\n- An adjacency matrix will be dynamically created to match the graph as it is being edited."\
	+ "\n\n- The rows of the matrix have 1's in the columns of nodes that they are connected to, and 0 where there is no connection."\
	+ "\n\n- When you are satisfied with the graph, you can preview and then generate an output file that will be populated with the graph's data."\
	+ "\n\n- Hovering the cursor over a button will display a tooltip indicating its function."\
	+ "\n\n- The buttons at the top of the white square have hotkeys numbered 1-6."\
	+ "\n\n- The black console at the bottom of the screen will display relevant prompts and accept input when needed."\
	+ "\n\n\n"\
	+ "\t\t[b][i]Created by:[/i][/b]\tChris Herzberg"\
	+ "\n\t\t\t\t  [b][i]Major:[/i][/b]\tComputer Engineering Senior at University of North Texas"\
	+ "\n\t[b][i]School email:[/i][/b]\tChristopherHerzberg@my.unt.edu"\
	+ "\n[b][i]Personal email:[/i][/b]\tChristopher.T.Herzberg@gmail.com"\
	+"\n\nPlease feel free to contact me if you experience any issues, or if you have any questions or requests."\
	+ "\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t[i]Version: " + version + "\t" + date
	output.bbcode_enabled = true
	output.text = about_str
	output.bbcode_text = about_str


func _on_Close_pressed():
	background.visible = false


func _on_PreviewButton_pressed():
	background.visible = true
	var string = file_output_string()
	output.bbcode_enabled = false
	output.text = string


func _on_GenFileButton_pressed():
	Signals.emit_signal("display_prompt", "Enter the file name (filename.txt OR directory/filename.txt):", 2)
	
	
func file_output_string() -> String:
	var resource_array = graph.get_available_resources()
	var string = "%Number of processes & resources\n"\
	+ "num_processes=" + String(main.num_processes)\
	+ "\nnum_resources=" + String(main.num_resources)\
	+ "\n\n%Total resources:\n"
	for i in resource_array.size():
		string += String(resource_array[i])
		if(i < resource_array.size() - 1):
			string += ","
	string += "\n\n%Adacency Matrix:\n"\
	+ matrix.string
	return string
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		_on_Options_pressed()
