extends CharacterState

@onready var animation_player = $"../../AnimationPlayer"

@export var state_countdown : float = 8
var countdown_variable : float = 3

@export_group("State Behaviour")
@export var chance_to_idle : float = 0.8
@export var chance_to_sit_down : float = 0
@export var chance_to_lay_down : float = 0
@export var chance_to_run : float = 0.2

@onready var label = $"../../Label"

func enter(_msg := {}) -> void:
	label.text = "WANDER"
	# Stop the timer before starting it
	character.state_timer.stop()
	# Start timer
	var random_countdown = randf_range(state_countdown - countdown_variable, state_countdown + countdown_variable)
	character.state_timer.wait_time = random_countdown
	character.state_timer.start()

func physics_update(delta):
	update_animation()
	steer(delta)

func change_state():
	var tolerance = 0.0001
	var total_chance = chance_to_idle + chance_to_sit_down + chance_to_lay_down + chance_to_run
	assert(abs(total_chance - 1.0) < tolerance)
	
	var actions = [
		{"chance": chance_to_idle, "action": "Idle"},
		{"chance": chance_to_sit_down, "action": "Sitting"},
		{"chance": chance_to_lay_down, "action": "Laying"},
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
		new_animation = "walking_r"
	elif character.look_direction >= PI/8 and character.look_direction < 3*PI/8:
		new_animation = "walking_d_r"
	elif character.look_direction >= 3*PI/8 and character.look_direction < 5*PI/8:
		new_animation = "walking_d"
	elif character.look_direction >= 5*PI/8 and character.look_direction < 7*PI/8:
		new_animation = "walking_d_l"
	elif character.look_direction >= -3*PI/8 and character.look_direction < -PI/8:
		new_animation = "walking_u_r"
	elif character.look_direction >= -5*PI/8 and character.look_direction < -3*PI/8:
		new_animation = "walking_u"
	elif character.look_direction >= -7*PI/8 and character.look_direction < -5*PI/8:
		new_animation = "walking_u_l"
	else:
		new_animation = "walking_l"

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



const WANDER_CIRCLE_RADIUS : int = 8
const WANDER_RANDOMNESS : float = 0.2

var wander_angle : float = 0

@export var wandering : bool = true


var last_direction_change = 0.0
const direction_change_interval = 0.2  # 200ms cooldown

func steer(delta):
	if Time.get_ticks_msec() - last_direction_change > direction_change_interval * 1000:
		var new_direction = avoid_obstacles_steering(delta)

		# Force AI to move sideways if stuck
		if stuck_time > 0.5:
			new_direction = Vector2((1 if randf() > 0.5 else -1) * 2.0, 0)  # Strong side push

		if new_direction.length() > 0.1:
			character.velocity = lerp(character.velocity, new_direction, 0.1)
			last_direction_change = Time.get_ticks_msec()

	var steering : Vector2 = Vector2.ZERO
	
	if wandering:
		steering += enclosure_steering()
		steering += wander_steering()
	
	steering += avoid_obstacles_steering(delta)
	character.velocity = lerp(character.velocity, character.velocity + steering, 0.1)
	character.velocity = character.velocity.limit_length(character.MAX_RUN_SPEED)
	character.move_and_slide()

func wander_steering() -> Vector2:
	wander_angle = randf_range(wander_angle - WANDER_RANDOMNESS, wander_angle + WANDER_RANDOMNESS)
	
	var vector_to_circle : Vector2 = character.velocity.normalized() * character.MAX_WALK_SPEED
	var desired_velocity : Vector2 = vector_to_circle + Vector2(WANDER_CIRCLE_RADIUS, 0).rotated(wander_angle)
	
	return desired_velocity - character.velocity


# TODO: Make enclosure_zone scale according viewport size
@export var enclosure_zone : Rect2 = Rect2(0, 0, 2000, 2000)

func enclosure_steering() -> Vector2:
	var desired_velocity : Vector2 = Vector2.ZERO
	if character.position.x < enclosure_zone.position.x:
		desired_velocity.x += 1
	elif character.position.x > enclosure_zone.position.x + enclosure_zone.size.x:
		desired_velocity.x -= 1
	if character.position.y < enclosure_zone.position.y:
		desired_velocity.y += 1
	elif character.position.y > enclosure_zone.position.y + enclosure_zone.size.y:
		desired_velocity.y -= 1
	
	desired_velocity = desired_velocity.normalized() * character.MAX_WALK_SPEED
	if desired_velocity != Vector2.ZERO:
		wander_angle = desired_velocity.angle()
		return desired_velocity - character.velocity
	else :
		return Vector2.ZERO

var avoid_force : int = 250

var last_valid_direction = Vector2.ZERO  # Store last movement direction
var stuck_time = 0.0  # Track how long AI is stuck

func avoid_obstacles_steering(delta) -> Vector2:
	var avoidance = Vector2.ZERO
	var count = 0
	var lateral_bias = Vector2.RIGHT if randf() > 0.5 else Vector2.LEFT  # Encourage side movement

	for raycast in character.raycasts.get_children():
		raycast.target_position.x = character.velocity.length() / 2
		if raycast.is_colliding():
			var obstacle = raycast.get_collider()
			var steer_direction = (character.position - obstacle.position).normalized() * avoid_force
			avoidance += steer_direction
			count += 1

	if count > 0:
		avoidance /= count  # Average out multiple obstacle forces
		avoidance = lerp(Vector2.ZERO, avoidance, 0.05)  # Smooth transition

		# If AI is moving up/down too much, start tracking time
		if abs(avoidance.y) > abs(avoidance.x):
			stuck_time += delta
		else:
			stuck_time = 0.0  # Reset when moving properly

		# If AI is stuck for 0.2s, force lateral movement
		if stuck_time > 0.2:
			avoidance = Vector2((1 if randf() > 0.5 else -1) * 2.0, 0)  # Strong side push
			stuck_time = 0.0  # Reset counter

		# Prevent rapid direction flipping
		if last_valid_direction.dot(avoidance) < -0.5:
			avoidance = last_valid_direction  # Prevent full reversal

	last_valid_direction = avoidance if avoidance.length() > 0.1 else last_valid_direction
	return avoidance




func _on_state_timer_timeout():
	if get_parent().state.name == self.name and character.state_timer.time_left < 1:
		change_state()
