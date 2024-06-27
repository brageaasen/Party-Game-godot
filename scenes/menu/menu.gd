extends Control

@onready var animation_player = $Art/AnimationPlayer
@onready var start_button = $StartMenu/StartButton
@onready var start_menu = $StartMenu
@onready var options_menu = $OptionsMenu
@onready var camera_2d = $"../Camera2D"

signal change_to_player_select

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)
	start_button.grab_focus()
	animation_player.play("logo_pulse")



func _on_start_button_pressed():
	set_process(false)
	self.hide()
	emit_signal("change_to_player_select")
	camera_2d.apply_shake()


func _on_options_button_pressed():
	start_menu.hide()
	options_menu.show()
	camera_2d.apply_shake()


func _on_quit_button_pressed():
	get_tree().quit()

