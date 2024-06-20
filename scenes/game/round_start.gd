extends Control

@onready var timer = $Timer
@onready var sec = $Seconds
@onready var start = $Start

@export var seconds : int = 3

signal start_round

func _ready():
	start.visible = false
	sec.text = str(seconds)
	timer.wait_time = 1.25
	timer.start()

func _on_timer_timeout():
	seconds -= 1
	if seconds == 0:
		sec.visible = false
		start.visible = true
	elif seconds < 0:
		timer.stop()
		start.visible = false
		start_round.emit()
	else:
		sec.text = str(seconds)
