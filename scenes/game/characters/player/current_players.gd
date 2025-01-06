class_name CurrentPlayers
extends Resource

signal added_player(player_index, player_name)
signal removed_player(player_index)

var players: Dictionary = {}

# Adds a player to the current players
func add(player: PlayerData):
	if player.player_index not in players:
		players[player.player_index] = player
		print("Added player: ", player.name)
		emit_signal("added_player", player.player_index, player.name)  # Emit signal when player is added
	else:
		print("Player already exists: ", player.name)

# Removes a player from the current players
func remove(player: PlayerData):
	if player.player_index in players:
		players.erase(player.player_index)
		print("Removed player: ", player.name)
		emit_signal("removed_player", player.player_index)  # Emit signal when player is removed
	else:
		print("Player does not exist: ", player.name)

# For debugging purposes, print all current players
func print_all_players():
	for key in players.keys():
		print("Player Index: ", key, ", Player Name: ", players[key].name)
