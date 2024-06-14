extends PlayerState

@onready var animation_player = $"../../AnimationPlayer"

func enter(_msg := {}) -> void:
	print("entered idle")

func physics_update(delta):
	player_movement(delta)
	update_animation()
	change_state()

func change_state():
	if player.get_input() != Vector2.ZERO:
		state_machine.transition_to("Walking")
	if Input.is_action_pressed(player.controls.run):
		state_machine.transition_to("Running")
	if Input.is_action_pressed(player.controls.jump):
		state_machine.transition_to("Jumping")
	if Input.is_action_pressed(player.controls.sit_down):
		state_machine.transition_to("Sitting")
	if Input.is_action_pressed(player.controls.lay_down):
		state_machine.transition_to("Laying")

func player_movement(delta):
	var player_input = player.get_input()
	
	if player_input == Vector2.ZERO:
		if player.velocity.length() > (player.FRICTION * delta):
			player.velocity -= player.velocity.normalized() * (player.FRICTION * delta)
		else:
			player.velocity = Vector2.ZERO
	else:
		player.velocity += (player_input * player.ACCEL * delta)
		player.velocity = player.velocity.limit_length(player.MAX_WALK_SPEED)
	
	player.move_and_slide()

func update_animation():
	var angle = player.last_direction.angle()

	# Determine the new animation based on the direction angle
	var new_animation = ""
	if angle >= -PI/8 and angle < PI/8:
		new_animation = "idle_r"
	elif angle >= PI/8 and angle < 3*PI/8:
		new_animation = "idle_d_r"
	elif angle >= 3*PI/8 and angle < 5*PI/8:
		new_animation = "idle_d"
	elif angle >= 5*PI/8 and angle < 7*PI/8:
		new_animation = "idle_d_l"
	elif angle >= -3*PI/8 and angle < -PI/8:
		new_animation = "idle_u_r"
	elif angle >= -5*PI/8 and angle < -3*PI/8:
		new_animation = "idle_u"
	elif angle >= -7*PI/8 and angle < -5*PI/8:
		new_animation = "idle_u_l"
	else:
		new_animation = "idle_l"

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
