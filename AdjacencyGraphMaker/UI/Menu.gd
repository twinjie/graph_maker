# User interface that allows the player to select game settings.
# To see how we update the actual window and rendering settings, see
# `Main.gd`.
extends Control

# Emitted when the user presses the "apply" button.
signal apply_button_pressed(settings)

# We store the selected settings in a dictionary
var _settings := {resolution = Vector2(1280, 720), 
					fullscreen = false, 
					auto_renum = true,
					label_matrix = true
					}


# Emit the `apply_button_pressed` signal, when user presses the button.
func _on_ApplyButton_pressed() -> void:
	# Send the last selected settings with the signal
	emit_signal("apply_button_pressed", _settings)


# Store the resolution selected by the user. As this function is connected
# to the `resolution_changed` signal, this will be executed any time the
# users chooses a new resolution
func _on_UISettingCheckbox_resolution_changed(new_resolution):
	_settings.resolution = new_resolution	


# Store the fullscreen setting. This will be called any time the users toggles
# the UIFullScreenCheckbox
func _on_UIFullscreenCheckbox_toggled(is_button_pressed: bool) -> void:
	_settings.fullscreen = is_button_pressed



func _on_AutoRenum_toggled(is_button_pressed: bool) -> void:
	_settings.auto_renum = is_button_pressed


func _on_CancelButton_pressed():
	self.visible = false


func _on_UISettingLabelMatrixCheckbox_toggled(is_button_pressed: bool) -> void:
	_settings.label_matrix = is_button_pressed


func _on_ExitButton_pressed():
	get_tree().quit()
