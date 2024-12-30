extends Control

@export var scale_focused = Vector2(1.5, 1.5)
@export var scale_unfocused = Vector2(1, 1)
@export var unfocused_alpha = 0.3
@export var spacing = 100
@export var starting_index = 0  # Starting button index in the center
@export var animation_duration = 0.1  # Duration of the animation

var current_index = 0  # Index of the currently focused button

signal index_changed(index)

func _ready():
	# Set the initial index for the center button
	current_index = starting_index
	emit_signal("index_changed", current_index)

	# Update button states on game launch (no animation)
	update_button_states(false)

	# Ensure the center button grabs focus after setup
	call_deferred("_force_center_focus")


func _force_center_focus():
	var center_button = get_child(current_index)
	center_button.grab_focus()


func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		move_selection(-1)
	elif Input.is_action_just_pressed("ui_right"):
		move_selection(1)


func move_selection(direction: int):
	# Allow input only if the node is visible
	if not get_parent().is_visible():
		return
	# Update the index circularly
	var total_buttons = get_child_count()
	current_index = (current_index + direction) % total_buttons
	if current_index < 0:
		current_index += total_buttons
		
	emit_signal("index_changed", current_index)


	# Update button states with animation
	update_button_states(true)

	# Ensure the center button grabs focus
	get_child(current_index).grab_focus()


func update_button_states(animated: bool):
	var total_buttons = get_child_count()
	var center_position = Vector2(size.x / 2, size.y / 2)

	for i in range(total_buttons):
		var button = get_child(i)

		# Calculate offset
		var offset = i - current_index
		if offset > total_buttons / 2:
			offset -= total_buttons
		elif offset < -total_buttons / 2:
			offset += total_buttons

		# Determine target properties
		var target_position: Vector2
		var target_scale: Vector2
		var target_modulate: Color

		if offset == 0:
			# Center button
			target_position = center_position - button.size / 2
			target_scale = scale_focused
			target_modulate = Color(1, 1, 1, 1)  # Fully visible
			button.focus_mode = Control.FOCUS_ALL
		elif offset == 1:
			# Right neighbor
			target_position = Vector2(center_position.x + spacing, center_position.y) - button.size / 2
			target_scale = scale_unfocused
			target_modulate = Color(1, 1, 1, unfocused_alpha)  # Semi-transparent
			button.focus_mode = Control.FOCUS_NONE
		elif offset == -1:
			# Left neighbor
			target_position = Vector2(center_position.x - spacing, center_position.y) - button.size / 2
			target_scale = scale_unfocused
			target_modulate = Color(1, 1, 1, unfocused_alpha)  # Semi-transparent
			button.focus_mode = Control.FOCUS_NONE
		else:
			# Hide all other buttons
			target_position = button.position  # Keep the same
			target_scale = scale_unfocused
			target_modulate = Color(1, 1, 1, 0)  # Fully transparent
			button.focus_mode = Control.FOCUS_NONE
			button.visible = false  # Hide button entirely after animation

		# Apply the animation if enabled
		if animated:
			var tween = create_tween()  # Create a new tween for this transition
			tween.tween_property(button, "position", target_position, animation_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(button, "scale", target_scale, animation_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(button, "modulate", target_modulate, animation_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
			button.visible = true  # Ensure button is visible during animation
		else:
			# Set properties directly (no animation)
			button.position = target_position
			button.set_scale(target_scale)
			button.modulate = target_modulate
			button.visible = target_modulate.a > 0  # Hide if alpha is 0
