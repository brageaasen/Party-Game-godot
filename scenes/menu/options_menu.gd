extends Control

@onready var start_menu = $"../StartMenu"
@onready var item_list : ItemList = $ItemList
const GAME_DATA = preload("res://scenes/game/game_data.tres")

func _ready():
	# Select "Random!" option on launch
	item_list.select(0, true)

func _on_item_list_item_selected(index):
	var selected_season = item_list.get_item_text(index)
	match selected_season:
		"Random!":
			GAME_DATA.season = GAME_DATA.Season.RANDOM
		"Summer":
			GAME_DATA.season = GAME_DATA.Season.SUMMER
		"Fall":
			GAME_DATA.season = GAME_DATA.Season.FALL
		"Winter":
			GAME_DATA.season = GAME_DATA.Season.WINTER
		"Spring":
			GAME_DATA.season = GAME_DATA.Season.SPRING

func _on_back_button_pressed():
	set_process(false)
	self.hide()
	start_menu.show()
