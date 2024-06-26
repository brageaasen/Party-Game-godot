extends Control

@onready var timer = $Timer
@onready var sec = $Seconds
@onready var start = $Start
@onready var tutorial = $"../Tutorial"

@export var seconds : int = 3

signal start_round

func _ready():
	start.visible = false
	sec.text = str(seconds)
	timer.wait_time = 1.25

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


func _on_tutorial_tutorial_finished():
	timer.start()
	self.show()
	tutorial.hide()
	tutorial.get_node("HoldDownButton").set_process(false)
	tutorial.set_process(false)
