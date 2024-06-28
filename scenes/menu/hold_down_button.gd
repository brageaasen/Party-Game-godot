extends Node2D

@export var signal_to_emit : String

@onready var animation_player = $AnimationPlayer
@onready var symbol_sprite = $Symbol

var max_players = 4
var button_hold_start = {} # Dictionary to keep track of button hold start times

# Constants for frame indices
const INITIAL_FRAME = 2
const PRESSED_FRAME = 6

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible == true:
		var all_buttons_released = true

		for i in range(1, max_players + 1):
			if Input.is_action_just_pressed("p%d_hold" % i):
				button_hold_start[i] = Time.get_ticks_msec()
				symbol_sprite.frame = PRESSED_FRAME # Set to pressed frame immediately
				# Start the animation if not already playing
				if not animation_player.is_playing():
					animation_player.play("button_hold")
			elif Input.is_action_pressed("p%d_hold" % i):
				all_buttons_released = false
				symbol_sprite.frame = PRESSED_FRAME

				if i in button_hold_start:
					var hold_duration = (Time.get_ticks_msec() - button_hold_start[i]) / 1000.0
					var animation_length = animation_player.get_current_animation_length()
					var seek_position = min(hold_duration / 1.0 * animation_length, animation_length)
					animation_player.seek(seek_position, true)

					if hold_duration >= 1.0:
						_on_button_held(i)
						button_hold_start.erase(i)
			elif Input.is_action_just_released("p%d_hold" % i):
				button_hold_start.erase(i)

		if all_buttons_released:
			symbol_sprite.frame = INITIAL_FRAME # Reset to initial frame when all buttons are released
			if animation_player.is_playing():
				# Reverse animation if all buttons are released
				animation_player.play_backwards("button_hold")


func _on_button_held(player_index):
	get_parent().emit_signal(signal_to_emit)
	# You can stop the animation if the button hold action is complete
	animation_player.stop()
	animation_player.seek(0, true)
