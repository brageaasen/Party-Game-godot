extends CharacterBody2D


# Player identifier
@export var controls : Resource = null
@onready var animation_player = $AnimationPlayer


const MAX_SPEED = 50.0
const ACCEL = 750.0
const FRICTION = 200.0

var input : Vector2 = Vector2.ZERO

func _physics_process(delta):
	player_movement(delta)
	update_animation()

func get_input():
	input.x = Input.get_action_strength(controls.move_right) - Input.get_action_strength(controls.move_left)
	input.y = Input.get_action_strength(controls.move_down) - Input.get_action_strength(controls.move_up)
	return input.normalized()

func jump():
	# Play jump animation
	# Disable collision shape to trick a real 2d jump
	pass

func player_movement(delta):
	var player_input = get_input()
	
	if player_input == Vector2.ZERO:
		if velocity.length() > (FRICTION * delta):
			velocity -= velocity.normalized() * (FRICTION * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += (player_input * ACCEL * delta)
		velocity = velocity.limit_length(MAX_SPEED)
	
	move_and_slide()

func update_animation():
	if velocity.length() == 0:
		animation_player.stop()
		return
	
	var direction = velocity.normalized()
	var angle = direction.angle()
	
	# Set the animation based on the direction angle
	if angle >= -PI/8 and angle < PI/8:
		animation_player.animation = "walking_r"
	elif angle >= PI/8 and angle < 3*PI/8:
		animation_player.animation = "walking_d_r"
	elif angle >= 3*PI/8 and angle < 5*PI/8:
		animation_player.animation = "walking_d"
	elif angle >= 5*PI/8 and angle < 7*PI/8:
		animation_player.animation = "walking_d_l"
	elif angle >= -3*PI/8 and angle < -PI/8:
		animation_player.animation = "walking_u_r"
	elif angle >= -5*PI/8 and angle < -3*PI/8:
		animation_player.animation = "walking_u"
	elif angle >= -7*PI/8 and angle < -5*PI/8:
		animation_player.animation = "walking_u_l"
	else:
		animation_player.animation = "walking_l"
	
	if !animation_player.is_playing():
		animation_player.play()
