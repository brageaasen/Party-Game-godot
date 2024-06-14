class_name Character
extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var look_direction = $LookDirection

const MAX_WALK_SPEED = 50.0
const MAX_RUN_SPEED = 100.0
const ACCEL = 750.0
const FRICTION = 200.0

# Look direction
var last_direction : Vector2
var interpolation_speed = 10.0  # Speed of interpolation

func update_look_direction(direction, delta):
	# Smoothly interpolate the direction
	last_direction = last_direction.lerp(direction, interpolation_speed * delta)
	look_direction.rotation = last_direction.angle() - PI / 2  # Adjust angle to align with correct direction

func get_look_direction():
	return last_direction
