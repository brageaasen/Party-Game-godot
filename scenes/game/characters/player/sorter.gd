extends Node2D

@onready var cursor = $Cursor # AnimatedSprite
@onready var grab_area = $GrabArea

# Player identifier
@export var controls : Resource = null

var grab_offset = Vector2(-10, 10)

# Reference to the currently grabbed object
var grabbed_object = null

# Sensitivity for the cursor movement
var sensitivity := 400.0

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hide the system cursor
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_cursor_position(delta)
	update_grabbed_object_position()
	grab()

func update_cursor_position(delta):
	# Get the input from the controller's left stick
	var move_input := Vector2(
		Input.get_action_strength(controls.move_right) - Input.get_action_strength(controls.move_left),
		Input.get_action_strength(controls.move_down) - Input.get_action_strength(controls.move_up)
	)

	# Calculate the new position
	var new_position = cursor.position + move_input * sensitivity * delta
	
	# Ensure the cursor stays within the screen bounds
	var screen_size := get_viewport_rect().size
	new_position.x = clamp(new_position.x, 0, screen_size.x)
	new_position.y = clamp(new_position.y, 0, screen_size.y)
	
	# Set the new position
	cursor.position = new_position
	grab_area.position = new_position # Ensure the grab area moves with the cursor

func update_grabbed_object_position():
	if grabbed_object != null:
		grabbed_object.global_position = cursor.global_position + grab_offset # Update the position of the grabbed object

func grab():
	if Input.is_action_just_pressed(controls.grab):
		cursor.play("closed")
		# TODO: Particles
		if grabbed_object == null:
			grab_object()
	if Input.is_action_just_released(controls.grab):
		if grabbed_object != null:
			release_object()
		cursor.play("open")
		# TODO: Particles

func grab_object():
	var closest_object = null
	var closest_distance = null

	for area in grab_area.get_overlapping_areas():
		if area.get_parent().is_in_group("grabbable"):
			var obj = area.get_parent()
			var distance = cursor.position.distance_to(area.get_global_position())
			if closest_object == null or distance < closest_distance:
				closest_object = obj
				closest_distance = distance

	if closest_object != null:
		grabbed_object = closest_object
		grabbed_object.global_position = cursor.global_position + grab_offset # Move the object to the offset position
		
		# Set the boolean (lifted) to true
		if grabbed_object.has_method("set_lifted"):
			grabbed_object.set_lifted(true)
		# If the grabbed object has a child node named "Lifted" and a node named "StateMachine", run: .transition_to("Lifted") on the "StateMachine" node
		if grabbed_object.has_node("StateMachine"):
			var state_machine = grabbed_object.get_node("StateMachine")
			if state_machine.has_method("transition_to"):
				state_machine.transition_to("Lifted")

func release_object():
	if grabbed_object != null:
		# Set the boolean (lifted) to false
		if grabbed_object.has_method("set_lifted"):
			grabbed_object.set_lifted(false)
		grabbed_object = null


func _on_area_2d_area_entered(area):
	# If area's parent node is of type, or extended from (class_name) Character, then it can be grabbed
	if area.get_parent().is_in_group("grabbable"):
		area.get_parent().add_to_group("can_be_grabbed")
