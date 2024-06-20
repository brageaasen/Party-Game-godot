extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# NPC path: res://scenes/game/characters/NPC/npc.tscn
# Player path: res://scenes/game/characters/player/player.tscn

# TODO: Get list of current players, dynamically give them resource controllers and resource data
# Pick one of them and make them the grabber, rest of them gets spawned in as a cat
# -> Spawned in with an animation of falling from the sky?

# On round end, screen turns dark and a light is emitted around the surviving players
# If grabber correctly sorts all of the players into one location and with zero NPC's,
# the round is cut short and the grabber wins
# Else, the grabber gets points for every player it captures, and minus for every NPC it captures
# -> So, only have one fenced location?

# Add dripple/splash effects on weather foliage

# Text announcement before round start who the sorter is, e.g, "Player 1 is the sorter!".
# And maybe let the players give themselves names so it is easier to distinguish.

func start_round():
	# Pick randomly one of the players as the sorter
	# Spawn in Player's and NPC's
	pass

func end_round():
	pass





func _on_round_start_start_round():
	start_round()


func _on_round_time_round_over():
	end_round()
