extends CharacterState

@onready var animation_player = $"../../AnimationPlayer"

@export var state_countdown : float = 12
var countdown_variable : float = 3

@export_group("State Behaviour")
@export var chance_to_idle : float = 0.2
@export var chance_to_wander : float = 0.2
@export var chance_to_sit_down : float = 0.6
@export var chance_to_run : float = 0

@onready var label = $"../../Label"

func enter(_msg := {}) -> void:
	label.text = "LAYING"
	# Stop the timer before starting it
	character.state_timer.stop()
	# Start timer
	var random_countdown = randf_range(state_countdown - countdown_variable, state_countdown + countdown_variable)
	character.state_timer.wait_time = random_countdown
	character.state_timer.start()

func physics_update(delta):
	update_animation()

func change_state():
	var tolerance = 0.0001
	var total_chance = chance_to_idle + chance_to_wander + chance_to_sit_down + chance_to_run
	assert(abs(total_chance - 1.0) < tolerance)
	
	var actions = [
		{"chance": chance_to_idle, "action": "Idle"},
		{"chance": chance_to_wander, "action": "Wander"},
		{"chance": chance_to_sit_down, "action": "Sitting"},
		{"chance": chance_to_run, "action": "RunningWander"}
	]
	
	var rand_value = randf()  # Generate a random number between 0 and 1
	var cumulative_chance = 0.0
	
	for action in actions:
		cumulative_chance += action["chance"]
		if rand_value < cumulative_chance:
			character.last_state = self
			state_machine.transition_to(action["action"])
			break


func update_animation():
	# Determine the new animation based on the direction angle
	var new_animation = ""
	if character.look_direction >= -PI/8 and character.look_direction < PI/8:
		new_animation = "laying_r"
	elif character.look_direction >= PI/8 and character.look_direction < 3*PI/8:
		new_animation = "laying_d_r"
	elif character.look_direction >= 3*PI/8 and character.look_direction < 5*PI/8:
		new_animation = "laying_d"
	elif character.look_direction >= 5*PI/8 and character.look_direction < 7*PI/8:
		new_animation = "laying_d_l"
	elif character.look_direction >= -3*PI/8 and character.look_direction < -PI/8:
		new_animation = "laying_u_r"
	elif character.look_direction >= -5*PI/8 and character.look_direction < -3*PI/8:
		new_animation = "laying_u"
	elif character.look_direction >= -7*PI/8 and character.look_direction < -5*PI/8:
		new_animation = "laying_u_l"
	else:
		new_animation = "laying_l"

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
	if get_parent().state.name == self.name and character.state_timer.time_left < 1:
		change_state()
