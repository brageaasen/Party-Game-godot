extends ColorRect

signal close_finished
signal open_finished


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "close":
		emit_signal("close_finished")
	elif anim_name == "open":
		emit_signal("open_finished")
