extends CharacterState

@onready var animation_player = $"../../AnimationPlayer"

@export var state_countdown : float = 4
var countdown_variable : float = 2


@export_group("State Behaviour")
@export var chance_to_idle : float = 0.2
@export var chance_to_wander : float = 0.8
@export var chance_to_lay_down : float = 0
@export var chance_to_sit_down : float = 0

@onready var label = $"../../Label"

func enter(_msg := {}) -> void:
	label.text = "RUNNING"
	# Stop the timer before starting it
	character.state_timer.stop()
	# Start timer
	var random_countdown = randf_range(state_countdown - countdown_variable, state_countdown + countdown_variable)
	print("Setting timer to: %f seconds" % random_countdown)
	character.state_timer.wait_time = random_countdown
	character.state_timer.start()

func physics_update(delta):
	update_animation()
	steer(delta)

func change_state():
	var tolerance = 0.0001
	var total_chance = chance_to_idle + chance_to_wander + chance_to_sit_down + chance_to_lay_down
	assert(abs(total_chance - 1.0) < tolerance)
	
	var actions = [
		{"chance": chance_to_idle, "action": "Idle"},
		{"chance": chance_to_wander, "action": "Wander"},
		{"chance": chance_to_sit_down, "action": "Sitting"},
		{"chance": chance_to_lay_down, "action": "Laying"}
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
		new_animation = "running_r"
	elif character.look_direction >= PI/8 and character.look_direction < 3*PI/8:
		new_animation = "running_d_r"
	elif character.look_direction >= 3*PI/8 and character.look_direction < 5*PI/8:
		new_animation = "running_d"
	elif character.look_direction >= 5*PI/8 and character.look_direction < 7*PI/8:
		new_animation = "running_d_l"
	elif character.look_direction >= -3*PI/8 and character.look_direction < -PI/8:
		new_animation = "running_u_r"
	elif character.look_direction >= -5*PI/8 and character.look_direction < -3*PI/8:
		new_animation = "running_u"
	elif character.look_direction >= -7*PI/8 and character.look_direction < -5*PI/8:
		new_animation = "running_u_l"
	else:
		new_animation = "running_l"

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

func steer(delta):
	var steering : Vector2 = Vector2.ZERO
	
	if wandering:
		steering += enclosure_steering()
		steering += wander_steering()
	
	steering += avoid_obstacles_steering()
	character.velocity += steering
	character.velocity = character.velocity.limit_length(character.MAX_RUN_SPEED)
	character.move_and_slide()

func wander_steering() -> Vector2:
	wander_angle = randf_range(wander_angle - WANDER_RANDOMNESS, wander_angle + WANDER_RANDOMNESS)
	
	var vector_to_circle : Vector2 = character.velocity.normalized() * character.MAX_RUN_SPEED
	var desired_velocity : Vector2 = vector_to_circle + Vector2(WANDER_CIRCLE_RADIUS, 0).rotated(wander_angle)
	
	return desired_velocity - character.velocity


@export var enclosure_zone : Rect2 = Rect2(0, 0, 200, 200)

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
	
	desired_velocity = desired_velocity.normalized() * character.MAX_RUN_SPEED
	if desired_velocity != Vector2.ZERO:
		wander_angle = desired_velocity.angle()
		return desired_velocity - character.velocity
	else :
		return Vector2.ZERO

var avoid_force : int = 500

func avoid_obstacles_steering() -> Vector2:
	for raycast in character.raycasts.get_children():
		raycast.target_position.x = character.velocity.length()
		if raycast.is_colliding():
			var obstacle : PhysicsBody2D = raycast.get_collider()
			return (character.position + character.velocity - obstacle.position).normalized() * avoid_force
	
	return Vector2.ZERO


func _on_state_timer_timeout():
	if get_parent().state.name == self.name and character.state_timer.time_left < 1:
		change_state()
