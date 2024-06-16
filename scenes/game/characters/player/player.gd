class_name Player
extends Character

# Player identifier
@export var controls : Resource = null

var input : Vector2 = Vector2.ZERO

func _physics_process(delta):
	if get_input() != Vector2.ZERO:
		update_look_direction(input, delta)

func get_input():
	input.x = Input.get_action_strength(controls.move_right) - Input.get_action_strength(controls.move_left)
	input.y = Input.get_action_strength(controls.move_down) - Input.get_action_strength(controls.move_up)
	return input.normalized()

# Look direction
var interpolation_speed = 10.0  # Speed of interpolation

func update_look_direction(direction, delta):
	# Smoothly interpolate the direction
	last_direction = last_direction.lerp(direction, interpolation_speed * delta)
	look_direction.rotation = last_direction.angle() - PI / 2  # Adjust angle to align with correct direction

func get_look_direction():
	return last_direction
