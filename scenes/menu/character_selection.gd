extends Control

var character_to_sprite: Dictionary = {
	"Black": "res://assets/sprites/characters/black_0.png",
	"Blue": "res://assets/sprites/characters/blue_0.png",
	"Brown": "res://assets/sprites/characters/brown_0.png",
	"Calico": "res://assets/sprites/characters/calico_0.png",
	"CottonCandyBlue": "res://assets/sprites/characters/cotton_candy_blue_0.png",
	"CottonCandyPink": "res://assets/sprites/characters/cotton_candy_pink_0.png",
	"Creme": "res://assets/sprites/characters/creme_0.png",
	"Dark": "res://assets/sprites/characters/dark_0.png",
	"GameBoy": "res://assets/sprites/characters/game_boy_0.png",
	"Ghost": "res://assets/sprites/characters/ghost_0.png",
	"Gold": "res://assets/sprites/characters/gold_0.png",
	"Grey": "res://assets/sprites/characters/grey_0.png",
	"Hairless": "res://assets/sprites/characters/hairless_0.png",
	"Indigo": "res://assets/sprites/characters/indigo_0.png",
	"Orange": "res://assets/sprites/characters/orange_0.png",
	"Peach": "res://assets/sprites/characters/peach_0.png",
	"Pink": "res://assets/sprites/characters/pink_0.png",
	"Radioactive": "res://assets/sprites/characters/radioactive_0.png",
	"Red": "res://assets/sprites/characters/red_0.png",
	"SealPoint": "res://assets/sprites/characters/seal_point_0.png",
	"Teal": "res://assets/sprites/characters/teal_0.png",
	"White": "res://assets/sprites/characters/white_0.png",
	"WhiteGrey": "res://assets/sprites/characters/white_grey_0.png",
	"Yellow": "res://assets/sprites/characters/yellow_0.png",
}

# Tracks locked characters (character_name -> player_index)
var locked_characters: Dictionary = {}

@export var current_players : Resource # Current players resource

@onready var cursor_container = $Cursors
@onready var player_container = $"../PlayerContainer"
@onready var player_select_screen = $".."

func _ready():
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
	cursor_container.get_child(player_index - 1)._hover_character()

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
	print("got it")
	sprite_node.texture = load(sprite_path as String)
	sprite_node.modulate.a = 0.5

func _on_character_selected(player_index, sprite, sprite_path):
	# Load the PlayerData resource
	var player_data_path = player_select_screen.player_data_paths.get(player_index)
	if player_data_path == null:
		print("Error: No path found for player index", player_index)
		return
	
	var player_data = load(player_data_path) as PlayerData
	if player_data == null:
		print("Error: Could not load PlayerData for path", player_data_path)
		return
	
	# Add character to player data
	player_data.character = sprite  # Update the character property in PlayerData
	print()
	print("PlayerData for index", player_index, "character set to:", player_data.character)
	print()
	
	# Update the sprite of the player's selected MenuCharacter
	var player_slot = player_container.get_child(player_index - 1)
	var sprite_node = player_slot.get_node("Sprite2D")
	sprite_node.texture = load(sprite_path as String)
	sprite_node.modulate.a = 1
	print(sprite_node.modulate.a)
	print("Player", player_index, " selected character:", sprite_path)

func _on_character_deselected(player_index):
	# Load the PlayerData resource
	var player_data_path = player_select_screen.player_data_paths.get(player_index)
	if player_data_path == null:
		print("Error: No path found for player index", player_index)
		return
	
	var player_data = load(player_data_path) as PlayerData
	if player_data == null:
		print("Error: Could not load PlayerData for path", player_data_path)
		return
	
	# Remove character from player data
	player_data.character = ""  # Update the character property in PlayerData
	# Reset the player's sprite
	var player_slot = player_container.get_child(player_index - 1)
	var sprite_node = player_slot.get_node("Sprite2D")
	#sprite_node.texture = null
	sprite_node.modulate.a = 0.5
	print("Player", player_index, " deselected their character.")
