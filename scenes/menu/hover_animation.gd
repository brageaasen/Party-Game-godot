extends TextureRect

# Assign your two textures in the Inspector
@export var hover_0 : Texture  # Texture to display when hovering
@export var hover_1 : Texture  # Texture to display when holding

var is_hovering = false  # Track if the mouse is hovering over the button
var is_pressed = false  # Track if the mouse button is held down on this button

var button : Button

func _ready():
	button = get_parent()
	
	# Set the initial texture to empty
	texture = null
	
	# Set the pivot point to the center of the button
	button.pivot_offset = button.size / 2

	# Connect signals from the parent button
	button.connect("mouse_entered", _on_mouse_entered)
	button.connect("mouse_exited", _on_mouse_exited)

func _process(delta):
	if is_hovering:
		if Input.is_action_just_pressed("all_menu_go"):
			is_pressed = true
			_update_texture()  # Update immediately on press
		if Input.is_action_just_released("all_menu_go"):
			is_pressed = false
			_update_texture()  # Update immediately on release
	else:
		is_pressed = false
		_update_texture()  # Update immediately on release
	
func _on_mouse_entered():
	is_hovering = true
	_update_texture()  # Update immediately on hover

func _on_mouse_exited():
	is_hovering = false
	_update_texture()  # Update immediately on hover exit

func _update_texture():
	# Update the texture based on hover and press state
	if is_pressed:
		texture = hover_1  # Show hover_1 when pressed
	elif is_hovering:
		texture = hover_0  # Show hover_0 when hovering
		# Scale the button
		button.scale = Vector2(1.25, 1.25)  
	else:
		texture = null  # Hide the texture if not hovered
		# Scale the button
		button.scale = Vector2(1, 1)  
