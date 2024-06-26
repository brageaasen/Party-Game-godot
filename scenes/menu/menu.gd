extends Control

@onready var animation_player = $Art/AnimationPlayer
@onready var start_button = $StartMenu/StartButton
@onready var start_menu = $StartMenu
@onready var options_menu = $OptionsMenu

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


func _on_options_button_pressed():
	start_menu.hide()
	options_menu.show()


func _on_quit_button_pressed():
	get_tree().quit()

