extends Control

@onready var back_button = $BackButton
@onready var circle = $Circle

signal back_button_pressed

var back_actions = ["p1_back", "p2_back", "p3_back", "p4_back", "p5_back", "p6_back", "p7_back", "p8_back", "p9_back"]

func _process(delta):
	# Skip processing if BackOption or its parent is not visible
	if not is_visible_in_tree():
		return
	
	if _is_any_action_pressed(back_actions):
		circle.play("pressed")
	elif _is_any_action_just_released(back_actions):
		circle.play("default")
		emit_signal("back_button_pressed")

func _is_any_action_pressed(actions: Array) -> bool:
	for action in actions:
		if Input.is_action_pressed(action):
			return true
	return false

func _is_any_action_just_released(actions: Array) -> bool:
	for action in actions:
		if Input.is_action_just_released(action):
			return true
	return false


func _on_back_button_button_down():
	circle.play("pressed")


func _on_back_button_button_up():
	circle.play("default")
