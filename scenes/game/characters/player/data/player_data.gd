class_name PlayerData
extends Resource

@export var player_index : int = 1
@export var score : int = 0
@export var name : String = "Player " + str(player_index)
@export var controls : PlayerControls = null
@export var character : String

var is_sorter = false
