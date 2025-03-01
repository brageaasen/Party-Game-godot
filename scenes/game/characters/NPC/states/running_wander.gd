extends CharacterState

@onready var animation_player = $"../../AnimationPlayer"
@onready var label = $"../../Label"

@export var state_countdown: float = 4.0
@export var countdown_variance: float = 2.0

@export_group("State Behaviour")
@export var chance_to_idle: float = 0.2
@export var chance_to_wander: float = 0.8
@export var chance_to_lay_down: float = 0.0
@export var chance_to_sit_down: float = 0.0

# Running wander settings
@export var wander_change_interval: float = 0.8  # seconds between picking new target
@export var wander_min_distance: float = 80.0      # minimum distance for a new target
@export var wander_max_distance: float = 150.0     # maximum distance for a new target
var wander_timer: float = 0.0
var wander_target: Vector2

# Obstacle avoidance settings
@export var avoid_force: float = 500.0

# Enclosure boundary (adjust as needed)
@export var enclosure_zone: Rect2 = Rect2(0, 0, 200, 200)

func enter(_msg := {}) -> void:
	label.text = "RUNNING"
	# Stop the state timer and start a new one with random countdown
	character.state_timer.stop()
	var random_countdown = randf_range(state_countdown - countdown_variance, state_countdown + countdown_variance)
	print("Running timer set to: %f seconds" % random_countdown)
	character.state_timer.wait_time = random_countdown
	character.state_timer.start()
	
	# Initialize wander target in front of the character
	wander_target = character.position + character.velocity.normalized() * wander_max_distance
	wander_timer = 0.0

func physics_update(delta: float) -> void:
	update_animation()
	
	# Update wander target at intervals
	wander_timer += delta
	if wander_timer >= wander_change_interval:
		wander_timer = 0.0
		_set_new_wander_target()
	
	# Determine desired velocity toward the wander target using run speed
	var desired_velocity = (wander_target - character.position).normalized() * character.MAX_RUN_SPEED
	
	# Add obstacle avoidance and enclosure correction
	desired_velocity += _calculate_avoidance(delta) * 0.5
	desired_velocity += _enclosure_correction()
	
	# Blend current velocity toward the new desired velocity smoothly
	character.velocity = character.velocity.lerp(desired_velocity, 0.1)
	character.velocity = character.velocity.limit_length(character.MAX_RUN_SPEED)
	
	character.move_and_slide()

func _set_new_wander_target() -> void:
	# Pick a new random direction and distance
	var angle = randf_range(-PI, PI)
	var distance = randf_range(wander_min_distance, wander_max_distance)
	wander_target = character.position + Vector2(cos(angle), sin(angle)) * distance

var prev_avoidance: Vector2 = Vector2.ZERO

func _calculate_avoidance(delta: float) -> Vector2:
	var avoidance: Vector2 = Vector2.ZERO
	var rays = [
		character.raycasts.get_node("Forward"),
		character.raycasts.get_node("Left"),
		character.raycasts.get_node("Right")
	]
	var count = 0
	for ray in rays:
		if ray.is_colliding():
			var collider = ray.get_collider()
			var push_vector: Vector2 = Vector2.ZERO
			
			if collider is StaticBody2D:
				var best_push: Vector2 = Vector2.ZERO
				var best_dist = INF
				for child in collider.get_children():
					if child is CollisionShape2D and child.shape is RectangleShape2D:
						var rect_shape = child.shape as RectangleShape2D
						var extents = rect_shape.extents
						# Convert NPC's global position into the child's local space.
						var local_pos = child.global_transform.affine_inverse() * character.position
						# Clamp local position to the rectangle bounds.
						var clamped_x = clamp(local_pos.x, -extents.x, extents.x)
						var clamped_y = clamp(local_pos.y, -extents.y, extents.y)
						var nearest_local = Vector2(clamped_x, clamped_y)
						# Convert the clamped point back to global space.
						var nearest_global = child.global_transform * nearest_local
						var push = character.position - nearest_global
						var dist = push.length()
						if dist < best_dist:
							best_dist = dist
							best_push = push.normalized()
				push_vector = best_push
			else:
				if collider is CollisionShape2D and collider.shape is RectangleShape2D:
					var rect_shape = collider.shape as RectangleShape2D
					var extents = rect_shape.extents
					var local_pos = collider.global_transform.affine_inverse() * character.position
					var clamped_x = clamp(local_pos.x, -extents.x, extents.x)
					var clamped_y = clamp(local_pos.y, -extents.y, extents.y)
					var nearest_local = Vector2(clamped_x, clamped_y)
					var nearest_global = collider.global_transform * nearest_local
					push_vector = (character.position - nearest_global).normalized()
				else:
					push_vector = (character.position - collider.global_position).normalized()
			
			var factor = (1.5 if ray.name == "Forward" else 0.75)
			avoidance += push_vector * avoid_force * factor
			count += 1
	if count > 0:
		avoidance /= count
	
	# Blend with the previous avoidance vector for smooth transitions.
	prev_avoidance = prev_avoidance.lerp(avoidance, 0.05 * delta)
	return prev_avoidance


func _enclosure_correction() -> Vector2:
	var correction: Vector2 = Vector2.ZERO
	if character.position.x < enclosure_zone.position.x:
		correction.x = 1
	elif character.position.x > enclosure_zone.position.x + enclosure_zone.size.x:
		correction.x = -1
	if character.position.y < enclosure_zone.position.y:
		correction.y = 1
	elif character.position.y > enclosure_zone.position.y + enclosure_zone.size.y:
		correction.y = -1
	if correction != Vector2.ZERO:
		return correction.normalized() * character.MAX_RUN_SPEED
	return Vector2.ZERO

func update_animation() -> void:
	# Determine running animation based on movement direction
	var new_animation: String = ""
	if character.velocity.length() < 0.1:
		new_animation = "idle"
	else:
		var angle = character.velocity.angle()
		if angle >= -PI/8 and angle < PI/8:
			new_animation = "running_r"
		elif angle >= PI/8 and angle < 3*PI/8:
			new_animation = "running_d_r"
		elif angle >= 3*PI/8 and angle < 5*PI/8:
			new_animation = "running_d"
		elif angle >= 5*PI/8 and angle < 7*PI/8:
			new_animation = "running_d_l"
		elif angle >= -3*PI/8 and angle < -PI/8:
			new_animation = "running_u_r"
		elif angle >= -5*PI/8 and angle < -3*PI/8:
			new_animation = "running_u"
		elif angle >= -7*PI/8 and angle < -5*PI/8:
			new_animation = "running_u_l"
		else:
			new_animation = "running_l"
	
	# Preserve current frame progress if animation changes
	var current_frame = animation_player.current_animation_position
	if animation_player.current_animation != new_animation:
		animation_player.play(new_animation)
		animation_player.seek(current_frame, true)
	elif not animation_player.is_playing():
		animation_player.play(new_animation)

func change_state() -> void:
	var tolerance = 0.0001
	var total_chance = chance_to_idle + chance_to_wander + chance_to_sit_down + chance_to_lay_down
	assert(abs(total_chance - 1.0) < tolerance)
	
	var actions = [
		{"chance": chance_to_idle, "action": "Idle"},
		{"chance": chance_to_wander, "action": "Wander"},
		{"chance": chance_to_sit_down, "action": "Sitting"},
		{"chance": chance_to_lay_down, "action": "Laying"}
	]
	
	var rand_value = randf()
	var cumulative = 0.0
	for action in actions:
		cumulative += action["chance"]
		if rand_value < cumulative:
			character.last_state = self
			state_machine.transition_to(action["action"])
			break

func _on_state_timer_timeout() -> void:
	if get_parent().state.name == self.name and character.state_timer.time_left < 1:
		change_state()
