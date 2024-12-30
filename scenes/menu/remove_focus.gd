extends VBoxContainer

func _ready():
	# Connect signals for all buttons
	for control in get_children():
		var button = control.get_child(0)
		if button is Button:
			print(button)
			button.mouse_filter = Control.MOUSE_FILTER_PASS  # Ensure it receives mouse input
			button.connect("mouse_entered", Callable(self, "_on_button_mouse_entered").bind(button))  # Bind button
			button.connect("mouse_exited", Callable(self, "_on_button_mouse_exited").bind(button))    # Bind button

func _on_button_mouse_entered(button):
	button.focus_mode = Control.FOCUS_ALL  # Allow focus when hovered

func _on_button_mouse_exited(button):
	button.focus_mode = Control.FOCUS_NONE  # Disable focus when not hovered
	button.release_focus()
