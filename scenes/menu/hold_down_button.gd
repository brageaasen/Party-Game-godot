extends Node2D

@export var signal_to_emit : String

var max_players = 4

var button_hold_start = {} # Dictionary to keep track of button hold start times

# TODO: Can now perform on_button_held infite times.. Bad

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible == true:
		for i in range(1, max_players + 1):
			if Input.is_action_just_pressed("p%d_hold" % i):
				button_hold_start[i] = Time.get_ticks_msec()
			elif Input.is_action_pressed("p%d_hold" % i):
				if i in button_hold_start and Time.get_ticks_msec() - button_hold_start[i] >= 1000:
					_on_button_held(i)
					button_hold_start.erase(i)
			elif Input.is_action_just_released("p%d_hold" % i):
				button_hold_start.erase(i)


func _on_button_held(player_index):
	get_parent().emit_signal(signal_to_emit)
