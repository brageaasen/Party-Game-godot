extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

var look_directions : Array = ["d", "d_l", "d_r"]
var possible_animations : Array = ["idle", "looking", "laying", "sitting"]

# Variables to store the chosen direction and the current animation index
var chosen_direction : String
var current_animation_index : int = 0
var time_to_next_animation : float = 0
var time_to_next_direction_change : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	load_random_sprite()
	# Randomly choose a direction once
	chosen_direction = look_directions[randi() % look_directions.size()]
	# Set the initial time to the next animation
	time_to_next_animation = randf_range(6, 10)
	# Set the initial time to the next direction change
	time_to_next_direction_change = randf_range(10, 15)
	# Start with the first animation
	_play_animation()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Decrease the time to the next animation
	time_to_next_animation -= delta
	# Decrease the time to the next direction change
	time_to_next_direction_change -= delta

	if time_to_next_animation <= 0:
		# Update the animation index
		current_animation_index = (current_animation_index + 1) % possible_animations.size()
		# Play the next animation
		_play_animation()
		# Reset the timer with a new random time
		time_to_next_animation = randf_range(6, 10)

	if time_to_next_direction_change <= 0:
		# Randomly choose a new direction
		chosen_direction = look_directions[randi() % look_directions.size()]
		# Play the current animation with the new direction
		_play_animation()
		# Reset the timer with a new random time
		time_to_next_direction_change = randf_range(10, 15)

# Function to play the current animation
func _play_animation():
	var animation_name = possible_animations[current_animation_index] + "_" + chosen_direction
	animation_player.play(animation_name)


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
				sprite_2d.texture = random_sprite
			else:
				print("Failed to load sprite: %s" % random_sprite_path)
	else:
		print("Failed to open directory: res://assets/sprites/characters/")
