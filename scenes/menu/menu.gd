extends Control

@onready var start_button = $VBoxContainer/StartButton

# Called when the node enters the scene tree for the first time.
func _ready():
	start_button.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_button_pressed():
	#get_tree().change_scene_to_file()
	pass


func _on_quit_button_pressed():
	get_tree().quit()
