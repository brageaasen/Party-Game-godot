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
