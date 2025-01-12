extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# TODO: Get list of current players, dynamically give them resource controllers and resource data
# Pick one of them and make them the grabber, rest of them gets spawned in as a cat
# -> Spawned in with an animation of falling from the sky?

# On round end, screen turns dark and a light is emitted around the surviving players
# If grabber correctly sorts all of the players into one location and with zero NPC's,
# the round is cut short and the grabber wins
# Else, the grabber gets points for every player it captures, and minus for every NPC it captures
# -> So, only have one fenced location?

# Add dripple/splash effects on weather foliage
# -> Random lifetime, on lifetime end, spawn splash effect



# Make hill y sort higher than kittens

# Text announcement before round start who the sorter is, e.g, "Player 1 is the sorter!".
# And maybe let the players give themselves names so it is easier to distinguish.

# TODO: Add game difficulty (number of NPC's)


@onready var tile_map = $Art/TileMap
@onready var enclosure = $Enclosure
@onready var circle_transition = $CanvasLayer/CircleTransition

@onready var tutorial = $CanvasLayer/Tutorial
@onready var leaderboard = $CanvasLayer/Leaderboard

@export var current_players : CurrentPlayers
@export var npc_count : int = 6

@onready var spawn_area = $SpawnArea

@export var not_caught_score : int = 3
@export var correct_guess_score : int = 3
@export var wrong_guess_score : int = 1

@export var game_data : GameData
@export var global_paths : GlobalPaths

signal round_start


func _ready():
	circle_transition.get_node("AnimationPlayer").play("open")
	tutorial.show()
	tile_map._change_enviorment_sprites(game_data.season)


func spawn_players():
	var player_indices = current_players.players.keys()
	if player_indices.size() == 0:
		print("No players to spawn.")
		return

	# Pick a random player to be the sorter
	var random_index = randi() % player_indices.size()
	var sorter_index = player_indices[random_index]
	var sorter_player = current_players.players[sorter_index]
	# TODO: Make false on round end.
	sorter_player.is_sorter = true

	# Load the sorter scene
	var sorter_scene = preload(global_paths.sorter_scene_path)
	var sorter_instance = sorter_scene.instantiate()
	sorter_instance.controls = sorter_player.controls

	# Get a valid spawn position for the sorter
	var sorter_spawn_position = spawn_area.get_center()
	print("SORTER POS")
	print(sorter_spawn_position)
	if sorter_spawn_position:
		sorter_instance.position = sorter_spawn_position
		add_child(sorter_instance)
	else:
		print("Could not find a valid spawn position for sorter")

	# Spawn the rest as players
	var player_scene = preload(global_paths.player_scene_path)
	for index in player_indices:
		if index == sorter_index:
			continue  # Skip the sorter
		var player = current_players.players[index]
		var player_instance = player_scene.instantiate()
		player_instance.controls = player.controls
		player_instance.player_data = player

		# Get a valid spawn position for the player
		var player_spawn_position = spawn_area.get_random_valid_spawn_position()
		if player_spawn_position:
			player_instance.position = player_spawn_position
			add_child(player_instance)
		else:
			print("Could not find a valid spawn position for player", player.name)

func spawn_npcs():
	var npc_scene = preload(global_paths.npc_scene_path)
	for i in range(npc_count):
		var npc_instance = npc_scene.instantiate()
		npc_instance.name = "NPC_" + str(i)

		var spawn_position = spawn_area.get_random_valid_spawn_position()
		if spawn_position:
			npc_instance.position = spawn_position
			add_child(npc_instance)
		else:
			print("Could not find a valid spawn position for NPC", i)


# Function to add score to the sorter-player
func calculate_sorter_score():
	var round_score = 0
	
	# Iterate through all objects currently in the enclosure
	for body in enclosure.objects_in_enclosure:
		# Check if the body has a name containing "Player" or "NPC"
		if body.name.contains("Player"):
			round_score += correct_guess_score
		elif body.name.contains("NPC"):
			round_score -= wrong_guess_score
	
	# Update the sorter's score
	for player in current_players.players.values():
		if player.is_sorter:
			player.score += round_score
			break # Only one sorter

# Function to add score to players not inside the enclosure
func calculate_player_score():
	# Iterate through all players in current_players
	for player in current_players.players.values():
		if player.is_sorter:
			continue
		var player_is_inside = false
		for body in enclosure.objects_in_enclosure:
			if body is Player and body.player_data.player_index == player.player_index:
				player_is_inside = true
				break
		# If the player is not inside the enclosure, add 3 to their score
		if not player_is_inside:
			player.score += not_caught_score

func start_round():
	spawn_players()
	spawn_npcs()
	
	emit_signal("round_start")

func end_round():
	# Update sorter score
	calculate_sorter_score()

	# Update player scores
	calculate_player_score()

	# Print updated player scores
	for player in current_players.players.values():
		print(player.name, " Score: ", player.score)
	
	leaderboard.update_leaderboard()
	leaderboard.show()




func _on_round_start_start_round():
	start_round()


func _on_round_time_round_over():
	end_round()
