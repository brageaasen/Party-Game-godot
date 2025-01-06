extends Control

@onready var player_select_screen = $".."
@onready var characters_container = $CharactersContainer
@onready var player_container = $PlayerContainer
var current_players = preload("res://scenes/game/characters/player/current_players.tres")
var menu_characters = []
var hovered_character = null  # Currently hovered character

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


@export var grid_columns: int = 4  # Number of columns in the grid

# Signals to notify selection or deselection
signal character_selected(player_index, character_name)
signal character_deselected(player_index)

# Maps players to selected characters
var player_character_map: Dictionary = {}

func _ready():
	# Populate the grid with character options
	_generate_character_grid()

func _generate_character_grid():
	for character_name in character_to_sprite.keys():
		var button = TextureButton.new()
		button.texture_normal = load(character_to_sprite[character_name])
		button.name = character_name  # Store the character name
		button.pressed.connect(_on_character_button_pressed.bind(character_name))
		add_child(button)

func _on_character_button_pressed(character_name: String):
	# Handle cursor-based player selection
	var cursor = get_node("/Cursors/Player1Cursor")
	if cursor and cursor.current_player != null:
		var player_index = cursor.current_player

		# Handle deselecting if the player already selected this character
		if player_character_map.has(player_index) and player_character_map[player_index] == character_name:
			_deselect_character(player_index)
			return

		# Otherwise, select the character for the player
		_select_character(player_index, character_name)

func _select_character(player_index: int, character_name: String):
	# Deselect the previous character, if any
	if player_character_map.has(player_index):
		_deselect_character(player_index)

	# Map the player to the selected character
	player_character_map[player_index] = character_name
	emit_signal("character_selected", player_index, character_name)

	# Update the sprite in the `PlayerSelectScreen`
	player_select_screen._on_character_selected(player_index, character_to_sprite[character_name])

func _deselect_character(player_index: int):
	if player_character_map.has(player_index):
		var character_name = player_character_map[player_index]
		player_character_map.erase(player_index)
		emit_signal("character_deselected", player_index)

		# Reset the player's sprite in the `PlayerSelectScreen`
		player_select_screen._on_character_deselected(player_index)
