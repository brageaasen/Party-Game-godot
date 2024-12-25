extends TextureRect

# Assign your two textures in the Inspector
@export var hover_0 : Texture
@export var hover_1 : Texture
@export var default_texture : Texture  # Texture to display when not hovering

var is_hovering = false
var current_image = 1
var timer = 0.0
const SWITCH_INTERVAL = 1.0  # Switch every second

func _ready():
	# Set the initial texture to the default (non-hover)
	texture = default_texture  

	# Signals are connected as in the original script
	var button = get_parent()
	button.connect("mouse_entered", _on_mouse_entered)
	button.connect("mouse_exited", _on_mouse_exited)
	button.connect("focus_entered", _on_focus_entered)
	button.connect("focus_exited", _on_focus_exited)

func _process(delta):
	# Update the timer regardless of hover state
	timer += delta
	if timer >= SWITCH_INTERVAL:
		timer = 0
		_toggle_image()

	# Set texture based on hover state
	if is_hovering:
		_apply_hover_image()
	else:
		texture = default_texture

func _on_mouse_entered():
	is_hovering = true

func _on_mouse_exited():
	# Stop hover only if not focused
	if !has_focus():
		is_hovering = false

func _on_focus_entered():
	is_hovering = true

func _on_focus_exited():
	# Stop hover only if the mouse isn't hovering
	if !is_hovering:
		is_hovering = false

func _toggle_image():
	# Toggle between hover_0 and hover_1 textures
	if current_image == 1:
		current_image = 2
	else:
		current_image = 1

func _apply_hover_image():
	# Apply the appropriate hover texture based on current_image
	if current_image == 1:
		texture = hover_0
	else:
		texture = hover_1
