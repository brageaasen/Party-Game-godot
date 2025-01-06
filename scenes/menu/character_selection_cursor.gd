extends Sprite2D

@onready var characters_container = $"../../CharactersContainer"

signal character_selected(player_index, character_name)
signal character_deselected(player_index)

@export var current_player : int  # The index of the player controlling this cursor
var current_col: int = 0  # Current column position in the grid
var current_row: int = 0  # Current row position in the grid
@export var portrait_offset: Vector2  # Distance between grid cells


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


func _process(delta):
	if visible:
		# Handle player movement
		if Input.is_action_just_pressed("p%d_move_right" % current_player):
			_move_cursor(1, 0)
		elif Input.is_action_just_pressed("p%d_move_left" % current_player):
			_move_cursor(-1, 0)
		elif Input.is_action_just_pressed("p%d_move_down" % current_player):
			_move_cursor(0, 1)
		elif Input.is_action_just_pressed("p%d_move_up" % current_player):
			_move_cursor(0, -1)

		# Handle character selection
		if Input.is_action_just_pressed("p%d_join" % current_player):
			_select_character()
		elif Input.is_action_just_pressed("p%d_leave" % current_player):
			_deselect_character()

func _move_cursor(dx: int, dy: int):
	var new_col = current_col + dx
	var new_row = current_row + dy

	if new_col < 0:
		new_col = characters_container.columns - 1
	elif new_col >= characters_container.columns:
		new_col = 0

	if new_row < 0:
		new_row = ceil(float(characters_container.get_child_count()) / characters_container.columns) - 1
	elif new_row >= ceil(float(characters_container.get_child_count()) / characters_container.columns):
		new_row = 0

	current_col = new_col
	current_row = new_row
	position = characters_container.position + Vector2(current_col * portrait_offset.x, current_row * portrait_offset.y)

func _select_character():
	var selected_index = current_row * characters_container.columns + current_col
	if selected_index < characters_container.get_child_count():
		var selected_character = characters_container.get_child(selected_index).name
		emit_signal("character_selected", current_player, character_to_sprite[selected_character])

func _deselect_character():
	emit_signal("character_deselected", current_player)
