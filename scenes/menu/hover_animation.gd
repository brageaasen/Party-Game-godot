extends TextureRect

# Assign your two textures in the Inspector
@export var hover_0 : Texture  # Texture to display when hovering
@export var hover_1 : Texture  # Texture to display when holding

var is_hovering = false  # Track if the mouse is hovering over the button
var is_pressed = false  # Track if the mouse button is held down on this button

func _ready():
	# Set the initial texture to empty
	texture = hover_0  

	# Connect signals from the parent button
	var button = get_parent()
	button.connect("mouse_entered", _on_mouse_entered)
	button.connect("mouse_exited", _on_mouse_exited)
	button.connect("pressed", _on_pressed)
	button.connect("released", _on_released)

func _on_mouse_entered():
	is_hovering = true
	_update_texture()  # Update immediately on hover

func _on_mouse_exited():
	is_hovering = false
	_update_texture()  # Update immediately on hover exit

func _on_pressed():
	is_pressed = true
	_update_texture()  # Update immediately on press

func _on_released():
	is_pressed = false
	_update_texture()  # Update immediately on release

func _update_texture():
	# Update the texture based on hover and press state
	if is_pressed:
		texture = hover_1  # Show hover_1 when pressed
	elif is_hovering:
		texture = hover_0  # Show hover_0 when hovering
	else:
		texture = null  # Hide the texture if not hovered
