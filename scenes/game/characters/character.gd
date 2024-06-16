class_name Character
extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var look_direction = $LookDirection

# Movement
const MAX_WALK_SPEED = 50.0
const MAX_RUN_SPEED = 100.0
const ACCEL = 750.0
const FRICTION = 200.0

# Look direction
var last_direction : Vector2
