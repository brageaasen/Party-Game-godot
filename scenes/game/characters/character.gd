class_name Character
extends CharacterBody2D

@onready var animation_player = $AnimationPlayer
@onready var look_direction = $LookDirection

@onready var sprite = $Sprite2D

# Sorter game-mode
var lifted = false

# Movement
const MAX_WALK_SPEED = 50.0
const MAX_RUN_SPEED = 100.0
const ACCEL = 750.0
const FRICTION = 200.0

# Look direction
var last_direction : Vector2

func _ready():
	load_random_sprite()

func load_random_sprite():
	var dir = DirAccess.open("res://assets/sprites/characters/")
	if dir:
		var files = []
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir() and file_name.ends_with(".png"):  # Assuming sprite sheets are .png files
				files.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()

		if files.size() > 0:
			var random_index = randi() % files.size()
			var random_sprite_path = "res://assets/sprites/characters/" + files[random_index]
			var random_sprite = load(random_sprite_path)
			if random_sprite:
				sprite.texture = random_sprite
			else:
				print("Failed to load sprite: %s" % random_sprite_path)
	else:
		print("Failed to open directory: res://assets/sprites/characters/")

func set_lifted(val):
	lifted = val
