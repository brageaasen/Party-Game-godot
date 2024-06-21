class_name CurrentPlayers
extends Resource

# TODO: Make empty later
const PLAYER_1_DATA = preload("res://scenes/game/characters/player/player_1_data.tres")
const PLAYER_2_DATA = preload("res://scenes/game/characters/player/player_2_data.tres")

func _init():
	print("test")
	add(PLAYER_1_DATA)
	add(PLAYER_2_DATA)

var players : Dictionary = { }

# Adds a player to the current players
func add(player: PlayerData):
	if player.player_index not in players:
		players[player.player_index] = player
		print("Added player: ", player.name)
	else:
		print("Player already exists: ", player.name)

# Removes a player from the current players
func remove(player: PlayerData):
	if player.player_index in players:
		players.erase(player.player_index)
		print("Removed player: ", player.name)
	else:
		print("Player does not exist: ", player.name)

# For debugging purposes, print all current players
func print_all_players():
	for key in players.keys():
		print("Player Index: ", key, ", Player Name: ", players[key].name, ", Score: ", players[key].score)
