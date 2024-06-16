extends CharacterState

@onready var animation_player = $"../../AnimationPlayer"
@onready var collision_shape_2d = $"../../CollisionShape2D"
@onready var collision_detection = $"../../GroundCheckArea/CollisionDetection"
@onready var label = $"../../Label"

# Counter for the number of colliders in the ground check area
var colliders_in_area = 0

func enter(_msg := {}) -> void:
	label.text = "LIFTED"
	update_animation()

func exit() -> void:
	collision_shape_2d.disabled = false

func physics_update(delta):
	update_animation()
	change_state()

func change_state():
	if not character.lifted:
		if character.velocity == Vector2.ZERO:
			state_machine.transition_to("Idle")
		else:
			state_machine.transition_to("Walking")

func update_animation():
	# Determine the new animation based on the direction angle
	var new_animation = ""
	if character.look_direction >= -PI/8 and character.look_direction < PI/8:
		new_animation = "lifted_r"
	elif character.look_direction >= PI/8 and character.look_direction < 3*PI/8:
		new_animation = "lifted_d_r"
	elif character.look_direction >= 3*PI/8 and character.look_direction < 5*PI/8:
		new_animation = "lifted_d"
	elif character.look_direction >= 5*PI/8 and character.look_direction < 7*PI/8:
		new_animation = "lifted_d_l"
	elif character.look_direction >= -3*PI/8 and character.look_direction < -PI/8:
		new_animation = "lifted_u_r"
	elif character.look_direction >= -5*PI/8 and character.look_direction < -3*PI/8:
		new_animation = "lifted_u"
	elif character.look_direction >= -7*PI/8 and character.look_direction < -5*PI/8:
		new_animation = "lifted_u_l"
	else:
		new_animation = "lifted_l"

	# Get the current frame to preserve the frame progress
	var current_frame = animation_player.current_animation_position

	# Only change the animation if it's different from the current one
	if animation_player.current_animation != new_animation:
		animation_player.play(new_animation)
		animation_player.seek(current_frame, true)
	else:
		# Ensure the animation continues playing if it's the same
		if !animation_player.is_playing():
			animation_player.play(new_animation)

func _on_ground_check_area_area_entered(area):
	colliders_in_area += 1

func _on_ground_check_area_area_exited(area):
	colliders_in_area -= 1
