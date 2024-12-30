extends Control

@onready var start_menu = $"../StartMenu"
@onready var options_selection = $OptionsSelection
@onready var camera_2d = $"../../Camera2D"

var GAME_DATA = preload("res://scenes/game/game_data.tres")

func _ready():
	# Select the first option ("Random!") on launch
	options_selection.current_index = 0
	_update_game_data(options_selection.current_index)
	options_selection.connect("index_changed", _on_options_selection_index_changed)

func _on_options_selection_index_changed(index):
	# Update the selected season based on the current index
	_update_game_data(index)

func _update_game_data(index):
	# Map the index to the correct season
	match index:
		0:
			GAME_DATA.season = GAME_DATA.Season.RANDOM
		1:
			GAME_DATA.season = GAME_DATA.Season.SUMMER
		2:
			GAME_DATA.season = GAME_DATA.Season.FALL
		3:
			GAME_DATA.season = GAME_DATA.Season.WINTER
		4:
			GAME_DATA.season = GAME_DATA.Season.SPRING

func _on_back_button_pressed():
	camera_2d.apply_shake()
	
	# Hide the current menu and show the start menu
	set_process(false)
	self.hide()
	start_menu.show()
