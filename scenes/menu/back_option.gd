extends HBoxContainer

@onready var back_button = $BackButton
@onready var circle = $Circle

signal back_button_pressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("p1_back") or Input.is_action_pressed("p2_back") or Input.is_action_pressed("p3_back") or Input.is_action_pressed("p4_back"):
		circle.play("pressed")
	elif Input.is_action_just_released("p1_back") or Input.is_action_just_released("p2_back") or Input.is_action_just_released("p3_back") or Input.is_action_just_released("p4_back"):
		circle.play("default")
		emit_signal("back_button_pressed")
