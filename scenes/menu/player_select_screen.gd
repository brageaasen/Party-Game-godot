extends Control

@onready var back_button = $BackButton
@onready var main = $"../Main"
@onready var player_container = $PlayerContainer # The parent node containing player slots in the scene

@export var current_players : Resource # Current players resource

var max_players = 4
var player_data_paths = {
	1 : "res://scenes/game/characters/player/data/player_1_data.tres",
	2 : "res://scenes/game/characters/player/data/player_2_data.tres",
	3 : "res://scenes/game/characters/player/data/player_3_data.tres",
	4 : "res://scenes/game/characters/player/data/player_4_data.tres",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	for i in range(max_players):
		player_container.get_child(i).hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible == true:
		for i in range(1, max_players + 1):
			if Input.is_action_just_pressed("p%d_join" % i):
				_add_player(i)
			elif Input.is_action_just_pressed("p%d_leave" % i):
				_remove_player(i)


func _add_player(player_index):
	if player_index in current_players.players:
		print("Player already joined.")
		return

	# Load the existing PlayerData resource
	var player_data_path = player_data_paths[player_index]
	var player_data = load(player_data_path)

	# Add player data to current players
	current_players.add(player_data)
	_update_lobby_display()

func _remove_player(player_index):
	if player_index not in current_players.players:
		print("Player not in lobby.")
		print(player_index)
		return

	# Remove player data from current players
	var player_data = current_players.players[player_index]
	current_players.remove(player_data)
	_update_lobby_display()

func _update_lobby_display():
	var index = 0
	for key in current_players.players.keys():
		var player_slot = player_container.get_child(index)
		player_slot.show()
		player_slot.get_node("PlayerName").text = current_players.players[key].name
		index += 1

	# Hide unused player slots
	for i in range(index, max_players):
		player_container.get_child(i).hide()


func _on_back_button_pressed():
	self.visible = false
	main.visible = true


func _on_main_change_to_player_select():
	self.visible = true

