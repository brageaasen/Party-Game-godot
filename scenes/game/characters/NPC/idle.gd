extends CharacterState

@onready var animation_player = $"../../AnimationPlayer"

@export var state_countdown : float = 2
var countdown_variable : float = 1

@export_group("State Behaviour")
@export var chance_to_wander : float = 0.4
@export var chance_to_sit_down : float = 0.2
@export var chance_to_lay_down : float = 0.2
@export var chance_to_run : float = 0.2

func enter(_msg := {}) -> void:
	print("NPC Entered idle")
	# Start timer
	var random_countdown = randf_range(state_countdown - countdown_variable, state_countdown + countdown_variable)
	character.state_timer.wait_time = random_countdown
	character.state_timer.start()

func physics_update(delta):
	update_animation()

func change_state():
	assert(chance_to_wander + chance_to_sit_down + chance_to_lay_down + chance_to_run == 1)
	var actions = [
		{"chance": chance_to_wander, "action": "Wander"},
		{"chance": chance_to_sit_down, "action": "Sitting"},
		{"chance": chance_to_lay_down, "action": "Laying"},
		{"chance": chance_to_run, "action": "RunningWander"}
	]
	
	var rand_value = randf()  # Generate a random number between 0 and 1
	var cumulative_chance = 0.0
	
	for action in actions:
		cumulative_chance += action["chance"]
		if rand_value < cumulative_chance:
			state_machine.transition_to(action["action"])
			break

func update_animation():
	var angle = character.raycasts.rotation
	
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


func _on_state_timer_timeout():
	if get_parent().state.name == self.name:
		print()
		print("Ran in idle")
		change_state()
