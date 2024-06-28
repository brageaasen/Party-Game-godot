extends HBoxContainer

@onready var back_button = $BackButton
@onready var square = $Square

signal back_button_pressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("p1_leave") or Input.is_action_pressed("p2_leave") or Input.is_action_pressed("p3_leave") or Input.is_action_pressed("p4_leave"):
		square.play("pressed")
	elif Input.is_action_just_released("p1_leave") or Input.is_action_just_released("p2_leave") or Input.is_action_just_released("p3_leave") or Input.is_action_just_released("p4_leave"):
		square.play("default")
		emit_signal("back_button_pressed")
