extends Sprite2D

@onready var characters_container = $"../../CharactersContainer"
@onready var character_selection = $"../.."
@onready var player_select_screen = $"../../.."

signal hover_character(player_index, character_sprite_path)
signal character_selected(player_index, character_sprite, character_sprite_path)
signal character_deselected(player_index)

var start_pos : Dictionary = {
	1 : [0, 0],
	2 : [0, 1],
	3 : [0, 3],
	4 : [0, 4],
	5 : [0, 5],
	6 : [1, 0],
	7 : [1, 1],
	8 : [1, 2],
	9 : [1, 3],
}

@export var current_player : int  # The index of the player controlling this cursor
@export var portrait_offset : Vector2  # Distance between grid cells
var initial_pos_offset : Vector2 = Vector2(20, 15)

var can_move : bool = true
var current_row : int
var current_col : int
var is_player_ready : bool = false
@onready var delay_timer = Timer.new()

# Tracks the currently locked character by this player
var locked_character : String = ""  # Default to an empty string

func _ready():
	current_row = start_pos[current_player][0]  # Current row position in the grid
	current_col = start_pos[current_player][1]  # Current column position in the grid
	
	# Calculate initial position based on current_row and current_col
	position = characters_container.position + Vector2(
		current_col * portrait_offset.x,
		current_row * portrait_offset.y
	) + initial_pos_offset
	
	player_select_screen.connect("player_ready_for_selection", _on_player_ready)
	player_select_screen.connect("player_not_ready_for_selection", _on_player_not_ready)
	
	# Create and configure the Timer
	delay_timer.wait_time = 0.1
	delay_timer.one_shot = true
	delay_timer.connect("timeout", _enable_player_ready)
	add_child(delay_timer)
	
	_hover_character()

func _on_player_not_ready(player_index):
	if player_index == current_player:
		is_player_ready = false

func _on_player_ready(player_index):
	if player_index == current_player:
		print("Starting delay for player:", player_index)
		
		# Reset and start the Timer
		if delay_timer.is_stopped():
			delay_timer.start()
		else:
			delay_timer.stop()
			delay_timer.start()

func _enable_player_ready():
	is_player_ready = true


func _process(delta):
	# Prevent race condition with player select script
	if is_player_ready:
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
			print("SET TO FALSE!!!")
		elif Input.is_action_just_pressed("p%d_leave" % current_player):
			_deselect_character()
		
func _move_cursor(dx: int, dy: int):
	# Don't allow movement if player has character
	if not can_move:
		return
	
	var new_col = current_col + dx
	var new_row = current_row + dy

	# Handle outside of grid for columns
	if new_col < 0:
		new_col = characters_container.columns - 1
	elif new_col >= characters_container.columns:
		new_col = 0
	
	# Handle outside of grid for rows
	if new_row < 0:
		new_row = ceil(float(characters_container.get_child_count()) / characters_container.columns) - 1
	elif new_row >= ceil(float(characters_container.get_child_count()) / characters_container.columns):
		new_row = 0

	current_col = new_col
	current_row = new_row
	
	position = characters_container.position + Vector2(
		current_col * portrait_offset.x,
		current_row * portrait_offset.y
	) + initial_pos_offset
	
	_hover_character()

func _select_character():
	var selected_index = current_row * characters_container.columns + current_col
	if selected_index < characters_container.get_child_count():
		var selected_character = characters_container.get_child(selected_index).name

		# Check if the character is already locked by another player
		if character_selection.locked_characters.has(selected_character):
			if character_selection.locked_characters[selected_character] != current_player:
				print("Character", selected_character, "is already locked by player", character_selection.locked_characters[selected_character])
				return

		# Unlock the previously locked character if any
		if locked_character != "":
			character_selection.locked_characters.erase(locked_character)
			emit_signal("character_deselected", current_player)
			print("Player", current_player, "unlocked previous character:", locked_character)

		# Lock the new character for the current player
		character_selection.locked_characters[selected_character] = current_player
		locked_character = selected_character
		
		# Hide cursor and prevent new movement
		self.hide()
		can_move = false
		

		emit_signal("character_selected", current_player, selected_character, character_selection.character_to_sprite[selected_character])
		print("Player", current_player, "selected and locked character:", selected_character)

func _deselect_character():
	# Unlock the currently locked character
	if locked_character != "":
		if character_selection.locked_characters.has(locked_character) and character_selection.locked_characters[locked_character] == current_player:
			character_selection.locked_characters.erase(locked_character)
			emit_signal("character_deselected", current_player)
			print("Player", current_player, "deselected and unlocked character:", locked_character)
			locked_character = ""  # Reset to an empty string
			
			# Show cursor and enable new movement
			self.show()
			can_move = true
		
		else:
			print("Character", locked_character, "is not locked by player", current_player)

func _hover_character():
	var selected_index = current_row * characters_container.columns + current_col
	if selected_index < characters_container.get_child_count():
		var selected_character = characters_container.get_child(selected_index).name
		emit_signal("hover_character", current_player, character_selection.character_to_sprite[selected_character])
