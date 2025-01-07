extends Control

@onready var main = $"../Main"
@onready var hold_down_button = $HoldDownButton
@onready var start_label = $StartLabel
@onready var back_option = $BackOption

var GAME_DATA = preload("res://scenes/game/game_data.tres")

@export var current_players : Resource # Current players resource

signal change_to_game_settings

var player_data_paths = {
	1 : "res://scenes/game/characters/player/data/player_1_data.tres",
	2 : "res://scenes/game/characters/player/data/player_2_data.tres",
	3 : "res://scenes/game/characters/player/data/player_3_data.tres",
	4 : "res://scenes/game/characters/player/data/player_4_data.tres",
	5 : "res://scenes/game/characters/player/data/player_5_data.tres",
	6 : "res://scenes/game/characters/player/data/player_6_data.tres",
	7 : "res://scenes/game/characters/player/data/player_7_data.tres",
	8 : "res://scenes/game/characters/player/data/player_8_data.tres",
	9 : "res://scenes/game/characters/player/data/player_9_data.tres",
}

@onready var character_selection = $CharacterSelection
@onready var player_container = $PlayerContainer  # Container for player slots
@onready var cursor_container = $CharacterSelection/Cursors  # Container for all cursors


func _ready():
	var back_button = back_option.get_node("BackButton")
	back_button.connect("back_button_pressed", _on_back_button_pressed)
	
	# Disable start button
	start_label.hide()
	hold_down_button.hide()
	hold_down_button.set_process(false)
	
	for i in range(GAME_DATA.max_players):
		_hide_player_slot(i)
	_update_lobby_display()
	
	current_players.connect("added_player", _on_player_added)
	current_players.connect("removed_player", _on_player_removed)
	
	# Connect cursor signals to handle character selection and deselection
	for cursor in cursor_container.get_children():
		cursor.connect("hover_character", _on_hover_character)
		cursor.connect("character_selected", _on_character_selected)
		cursor.connect("character_deselected", _on_character_deselected)

	# Update cursors based on current players
	_update_cursors()

func _on_player_added(player_index, player_name):
	_update_cursors()  # Update cursors dynamically

func _on_player_removed(player_index):
	_update_cursors()  # Update cursors dynamically


func _update_cursors():
	# Debug: Print the current players
	print("Current players:", current_players.players)

	# Make cursors visible only for joined players
	for cursor in cursor_container.get_children():
		cursor.visible = cursor.current_player in current_players.players.keys()
		print("Cursor for player", cursor.current_player, "visibility set to", cursor.visible)


func _on_hover_character(player_index, sprite_path):
	# Update the sprite of the player's selected MenuCharacter
	var player_slot = player_container.get_child(player_index - 1)
	var sprite_node = player_slot.get_node("Sprite2D")
	sprite_node.texture = load(sprite_path as String)
	sprite_node.modulate.a = 0.5

func _on_character_selected(player_index, sprite, sprite_path):
	# Add character to player data
	player_data_paths.get(player_index).character = character_selection.character_to_sprite[sprite]
	
	
	# Update the sprite of the player's selected MenuCharacter
	var player_slot = player_container.get_child(player_index - 1)
	var sprite_node = player_slot.get_node("Sprite2D")
	sprite_node.texture = load(sprite_path as String)
	sprite_node.modulate.a = 1
	print("Player", player_index, "selected character:", sprite_path)

func _on_character_deselected(player_index):
	# Reset the player's sprite
	var player_slot = player_container.get_child(player_index - 1)
	var sprite_node = player_slot.get_node("Sprite2D")
	#sprite_node.texture = null
	sprite_node.modulate.a = 0.5
	print("Player", player_index, "deselected their character.")

# Dictionary to keep track of which player is in which slot
var player_slots = {}

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
		for i in range(1, GAME_DATA.max_players + 1):
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
	
	if player_data.character != "": # If player has selected a character, exit character first
		print("Exit characte before lobby")
		return
	
	current_players.remove(player_data)
	
	# Remove the player from the slot
	player_slots.erase(player_index)
	
	_update_lobby_display()

var SEASON_HILL_TEXTURES_SELECTED = {
	GAME_DATA.Season.SUMMER: "res://assets/ui/player_select/SUMMER_grass_selected_player.png",
	GAME_DATA.Season.SPRING: "res://assets/ui/player_select/SPRING_grass_selected_player.png",
	GAME_DATA.Season.FALL:   "res://assets/ui/player_select/FALL_grass_selected_player.png",
	GAME_DATA.Season.WINTER: "res://assets/ui/player_select/WINTER_grass_selected_player.png"
}

var SEASON_HILL_TEXTURES_DE_SELECTED = {
	GAME_DATA.Season.SUMMER: "res://assets/ui/player_select/SUMMER_grass_de_selected_player.png",
	GAME_DATA.Season.SPRING: "res://assets/ui/player_select/SPRING_grass_de_selected_player.png",
	GAME_DATA.Season.FALL:   "res://assets/ui/player_select/FALL_grass_de_selected_player.png",
	GAME_DATA.Season.WINTER: "res://assets/ui/player_select/WINTER_grass_de_selected_player.png"
}

func _update_hill_texture(hill: Sprite2D, is_player_joined: bool):
	if is_player_joined:
		if SEASON_HILL_TEXTURES_SELECTED.has(GAME_DATA.season):
			hill.texture = load(SEASON_HILL_TEXTURES_SELECTED[GAME_DATA.season])
		else:
			print("Invalid season for selected hill texture:", GAME_DATA.season)
	else:
		if SEASON_HILL_TEXTURES_DE_SELECTED.has(GAME_DATA.season):
			hill.texture = load(SEASON_HILL_TEXTURES_DE_SELECTED[GAME_DATA.season])
		else:
			print("Invalid season for de-selected hill texture:", GAME_DATA.season)
	hill.visible = true



func _update_lobby_display():
	# Hide all player slots initially
	for i in range(GAME_DATA.max_players):
		_hide_player_slot(i)

	# Show players in their assigned slots
	for player_index in player_slots.keys():
		var slot_index = player_slots[player_index]
		var player_slot = player_container.get_child(slot_index)
		var player_sprite = player_slot.get_node("Sprite2D")
		var player_hill = player_slot.get_node("Hill")
		var player_shadow = player_slot.get_node("Shadow")
		var player_name = player_slot.get_node("PlayerName")
		var to_join_label = player_slot.get_node("ToJoin")
		var join_button_image = player_slot.get_node("JoinButton")
		
		# Update player visuals for joined players
		player_slot.show()
		player_sprite.show()
		player_shadow.show()
		player_name.text = current_players.players[player_index].name
		player_name.show()
		to_join_label.hide()
		join_button_image.hide()
		join_button_image.play("press")
		
		# Update hill texture to selected for joined players
		_update_hill_texture(player_hill, true)
	
	# Handle empty slots (not joined players)
	for i in range(GAME_DATA.max_players):
		if i not in player_slots.values():
			var player_slot = player_container.get_child(i)
			var player_hill = player_slot.get_node("Hill")
			var player_sprite = player_slot.get_node("Sprite2D")
			var player_shadow = player_slot.get_node("Shadow")
			var player_name = player_slot.get_node("PlayerName")
			var to_join_label = player_slot.get_node("ToJoin")
			var join_button_image = player_slot.get_node("JoinButton")

			player_slot.show()
			player_sprite.hide()
			player_shadow.hide()
			player_hill.show()
			player_name.hide()
			print(player_name.text)
			to_join_label.show()
			join_button_image.show()
			join_button_image.play("press")
			
			# Update hill texture to de-selected for not joined players
			_update_hill_texture(player_hill, false)


	
	# Handle empty slots
	for i in range(GAME_DATA.max_players):
		if i not in player_slots.values():
			var player_slot = player_container.get_child(i)
			var player_hill = player_slot.get_node("Hill")
			var player_sprite = player_slot.get_node("Sprite2D")
			var player_shadow = player_slot.get_node("Shadow")
			var player_name = player_slot.get_node("PlayerName")
			var to_join_label = player_slot.get_node("ToJoin")
			var join_button_image = player_slot.get_node("JoinButton")

			player_slot.show()
			player_sprite.hide()
			player_shadow.hide()
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
	
	# Disable child processing explicitly
	back_option.set_process(false)


func _on_main_change_to_player_select():
	set_process(true)
	self.show()
	
	# Enable child processing explicitly
	back_option.set_process(true)
