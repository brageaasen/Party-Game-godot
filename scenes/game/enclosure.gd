extends Area2D

var objects_in_enclosure: Array = []

func _ready():
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	objects_in_enclosure.append(body)

func _on_body_exited(body):
	objects_in_enclosure.erase(body)
