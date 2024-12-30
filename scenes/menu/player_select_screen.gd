extends Control

@onready var main = $"../Main"
@onready var player_container = $PlayerContainer # The parent node containing player slots in the scene
@onready var hold_down_button = $HoldDownButton
@onready var start_label = $StartLabel

const GAME_DATA = preload("res://scenes/game/game_data.tres")

@export var current_players : Resource # Current players resource

signal change_to_game_settings

var max_players = 4
var player_data_paths = {
	1 : "res://scenes/game/characters/player/data/player_1_data.tres",
	2 : "res://scenes/game/characters/player/data/player_2_data.tres",
	3 : "res://scenes/game/characters/player/data/player_3_data.tres",
	4 : "res://scenes/game/characters/player/data/player_4_data.tres",
}

# Dictionary to keep track of which player is in which slot
var player_slots = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	# Disable start button
	start_label.hide()
	hold_down_button.hide()
	hold_down_button.set_process(false)
	
	for i in range(max_players):
		_hide_player_slot(i)
	_update_lobby_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_players.players.size() >= 2:
		# Enable start button
		start_label.show()
		hold_down_button.show()
		hold_down_button.set_process(true)
	else:
		# Disable start button
		start_label.hide()
		hold_down_button.hide()
		hold_down_button.set_process(false)
	
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
	
	# Assign the player to a slot
	player_slots[player_index] = player_index - 1
	
	_update_lobby_display()

func _remove_player(player_index):
	if player_index not in current_players.players:
		print("Player not in lobby.")
		print(player_index)
		return

	# Remove player data from current players
	var player_data = current_players.players[player_index]
	current_players.remove(player_data)
	
	# Remove the player from the slot
	player_slots.erase(player_index)
	
	_update_lobby_display()


func _update_lobby_display():
	# Hide all player slots initially
	for i in range(max_players):
		_hide_player_slot(i)
	

	# Show players in their assigned slots
	for player_index in player_slots.keys():
		var slot_index = player_slots[player_index]
		var player_slot = player_container.get_child(slot_index)
		var player_sprite = player_slot.get_node("Sprite2D")
		var player_shadow = player_slot.get_node("Shadow")
		var player_name = player_slot.get_node("PlayerName")
		var to_join_label = player_slot.get_node("ToJoin")
		var join_button_image = player_slot.get_node("JoinButton")
		
		player_slot.show()
		player_sprite.show()
		player_shadow.show()
		player_name.show()
		player_name.text = current_players.players[player_index].name
		to_join_label.hide()
		join_button_image.hide()
		join_button_image.play("press")
		
		match GAME_DATA.season:
			GAME_DATA.Season.SUMMER:
				player_slot.get_node("Hill").texture = preload("res://assets/ui/player_select/SUMMER_grass_selected_player.png")
			GAME_DATA.Season.SPRING:
				player_slot.get_node("Hill").texture = preload("res://assets/ui/player_select/SPRING_grass_selected_player.png")
			GAME_DATA.Season.FALL:
				player_slot.get_node("Hill").texture = preload("res://assets/ui/player_select/FALL_grass_selected_player.png")
			GAME_DATA.Season.WINTER:
				player_slot.get_node("Hill").texture = preload("res://assets/ui/player_select/WINTER_grass_selected_player.png")
		player_slot.get_node("Hill").show()
		
	# Show "To Join" label and button image for empty slots
	for i in range(max_players):
		if i not in player_slots.values():
			var player_slot = player_container.get_child(i)
			var player_sprite = player_slot.get_node("Sprite2D")
			var player_shadow = player_slot.get_node("Shadow")
			var player_hill = player_slot.get_node("Hill")
			var player_name = player_slot.get_node("PlayerName")
			var to_join_label = player_slot.get_node("ToJoin")
			var join_button_image = player_slot.get_node("JoinButton")

			player_slot.show()
			player_sprite.hide()
			player_shadow.hide()
			player_hill.hide()
			player_name.hide()
			to_join_label.show()
			join_button_image.show()
			join_button_image.play("press")
		

func _hide_player_slot(slot_index):
	var player_slot = player_container.get_child(slot_index)
	var player_name = player_slot.get_node("PlayerName")
	var to_join_label = player_slot.get_node("ToJoin")
	var join_button_image = player_slot.get_node("JoinButton")

	player_slot.hide()
	player_name.hide()
	to_join_label.hide()
	join_button_image.hide()


func _on_back_button_pressed():
	set_process(false)
	self.hide()
	main.show()


func _on_main_change_to_player_select():
	set_process(true)
	self.show()
