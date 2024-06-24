extends Control

@onready var animation_player = $Art/AnimationPlayer
@onready var start_button = $VBoxContainer/StartButton
@onready var main = $"."

signal change_to_player_select

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()
	animation_player.play("logo_pulse")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	main.visible = false
	emit_signal("change_to_player_select")


func _on_quit_button_pressed():
	get_tree().quit()
