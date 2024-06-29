extends Control

@onready var player_select_screen = $"../PlayerSelectScreen"
@onready var camera_2d = $"../Camera2D"
@onready var circle_transition = $"../CircleTransition"

signal change_to_player_select

func _on_back_button_pressed():
	self.hide()
	player_select_screen.show()
	player_select_screen.get_node("HoldDownButton").set_process(true)


func _on_everything_button_pressed():
	circle_transition.get_node("AnimationPlayer").play("close")

func _on_circle_transition_close_finished():
	get_tree().change_scene_to_file("res://scenes/game/sort_the_cats.tscn")

func _on_player_select_screen_change_to_game_settings():
	set_process(true)
	self.show()
	player_select_screen.hide()
	player_select_screen.get_node("HoldDownButton").set_process(false)
	camera_2d.apply_shake()
