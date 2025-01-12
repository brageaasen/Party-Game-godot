extends Control

@onready var sort_the_cats = $"../.."

@onready var timer = $Timer
@onready var blink_timer = $BlinkTimer

@export var round_time_minutes: int = 1
@export var round_time_seconds: int = 30

@onready var minutes = $HBoxContainer/Minutes
@onready var seconds = $HBoxContainer/Seconds
@onready var m_seconds = $HBoxContainer/MSeconds

signal round_over

# Total round time in seconds
var total_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	sort_the_cats.connect("round_start", _on_round_start_start_round)
	
	self.visible = false
	
	total_time = round_time_minutes * 60 + round_time_seconds
	timer.wait_time = 0.01  # Set timer to tick every 0.01 seconds (10 milliseconds)
	minutes.visible = false
	seconds.visible = false
	blink_timer.wait_time = 0.5  # Set blink timer to tick every 0.5 seconds (500 milliseconds)
	blink_timer.connect("timeout", _on_blink_timer_timeout)

func _on_timer_timeout():
	if total_time <= 0:
		timer.stop()
		round_finished()
	else:
		total_time -= timer.wait_time
		update_timer_display(total_time)

func update_timer_display(time_left):
	var minutes_left = int(time_left) / 60
	var seconds_left = int(time_left) % 60
	var milliseconds_left = int((time_left - int(time_left)) * 100)

	minutes.text = str(minutes_left) + ":"
	seconds.text = str(seconds_left).pad_zeros(2)
	m_seconds.text = str(milliseconds_left).pad_zeros(2)

func round_finished():
	round_over.emit()
	blink_timer.start()


func _on_round_start_start_round():
	timer.start()
	self.visible = true
	minutes.visible = true
	seconds.visible = true

func _on_blink_timer_timeout():
	minutes.visible = !minutes.visible
	seconds.visible = !seconds.visible
	#m_seconds.visible = !m_seconds.visible
