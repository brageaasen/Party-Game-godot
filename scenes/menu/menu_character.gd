extends Node2D

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer

@export var player_data : Resource

var look_directions : Array = ["d", "d_l", "d_r"]
var possible_animations : Array = ["idle", "looking", "laying", "sitting"]

# Define possible transitions between states
var transitions : Dictionary = {
	"idle": ["sitting", "laying"],
	"sitting": ["idle", "laying", "looking"],
	"laying": ["idle"],
	"looking": ["idle", "sitting", "laying"]
}

# Variables to store the chosen direction and the current animation index
var chosen_direction : String
var current_animation : String = "idle"
var time_to_next_animation : float = 0
var time_to_next_direction_change : float = 0

# Indicates if we're waiting for the current animation to finish before changing direction
var waiting_for_animation_to_finish : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_parent().name == "PlayerContainer":
		self.sprite_2d.modulate.a = 0.5
	else:
		load_random_sprite()
	
	# Randomly choose a direction once
	chosen_direction = look_directions[randi() % look_directions.size()]
	# Set the initial time to the next animation
	time_to_next_animation = randf_range(0, 3)
	# Set the initial time to the next direction change
	time_to_next_direction_change = randf_range(10, 15)
	# Start with the first animation
	_play_animation()

	# Connect the animation finished signal
	animation_player.connect("animation_finished", _on_animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if waiting_for_animation_to_finish:
		return

	# Decrease the time to the next animation
	time_to_next_animation -= delta
	# Decrease the time to the next direction change
	time_to_next_direction_change -= delta

	if time_to_next_animation <= 0 and not waiting_for_animation_to_finish:
		_select_next_animation()
		# Reset the timer with a new random time
		time_to_next_animation = randf_range(4, 8)

	if time_to_next_direction_change <= 0 and not waiting_for_animation_to_finish:
		waiting_for_animation_to_finish = true

# Function to select the next animation
func _select_next_animation():
	# Select the next animation based on the current animation and its possible transitions
	var next_animations = transitions[current_animation]
	var next_animation = next_animations[randi() % next_animations.size()]
	# Ensure we don't transition to the same animation in the same direction
	while next_animation == current_animation:
		next_animation = next_animations[randi() % next_animations.size()]
	current_animation = next_animation
	_play_animation()

# Function to play the current animation
func _play_animation():
	var animation_name = current_animation + "_" + chosen_direction
	animation_player.play(animation_name)

# Called when the current animation finishes
func _on_animation_finished(animation_name):
	if waiting_for_animation_to_finish:
		# Allow some time before changing direction and starting the next animation
		await(get_tree().create_timer(time_to_next_animation).timeout)
		# Change the direction and play the current animation with the new direction
		chosen_direction = look_directions[randi() % look_directions.size()]
		waiting_for_animation_to_finish = false
		time_to_next_direction_change = randf_range(10, 15)
		_select_next_animation()
	else:
		# Allow some time before starting the next animation
		await(get_tree().create_timer(time_to_next_animation).timeout)
		_select_next_animation()

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
