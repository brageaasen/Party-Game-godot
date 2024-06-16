extends CharacterState

@onready var animation_player = $"../../AnimationPlayer"
@onready var collision_shape_2d = $"../../CollisionShape2D"
@onready var collision_detection = $"../../GroundCheckArea/CollisionDetection"


func enter(_msg := {}) -> void:
	# Turn off Collision while jumping
	collision_shape_2d.disabled = true
	
	collision_detection.disabled = false

func physics_update(delta):
	player_movement(delta)
	update_animation()
	change_state()

func change_state():
	if animation_player.current_animation_position >= animation_player.current_animation_length:
		state_machine.transition_to("Falling")

func player_movement(delta):
	var player_input = character.get_input()
	
	if player_input == Vector2.ZERO:
		if character.velocity.length() > (character.FRICTION * delta):
			character.velocity -= character.velocity.normalized() * (character.FRICTION * delta)
		else:
			character.velocity = Vector2.ZERO
	else:
		character.velocity += (player_input * character.ACCEL * delta)
		character.velocity = character.velocity.limit_length(character.MAX_WALK_SPEED)
	
	character.move_and_slide()


func update_animation():

	var angle = character.last_direction.angle()

	# Determine the new animation based on the direction angle
	var new_animation = ""
	if angle >= -PI/8 and angle < PI/8:
		new_animation = "jumping_r"
	elif angle >= PI/8 and angle < 3*PI/8:
		new_animation = "jumping_d_r"
	elif angle >= 3*PI/8 and angle < 5*PI/8:
		new_animation = "jumping_d"
	elif angle >= 5*PI/8 and angle < 7*PI/8:
		new_animation = "jumping_d_l"
	elif angle >= -3*PI/8 and angle < -PI/8:
		new_animation = "jumping_u_r"
	elif angle >= -5*PI/8 and angle < -3*PI/8:
		new_animation = "jumping_u"
	elif angle >= -7*PI/8 and angle < -5*PI/8:
		new_animation = "jumping_u_l"
	else:
		new_animation = "jumping_l"

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
