extends HBoxContainer

@onready var portrait : TextureRect = $Portrait
@onready var player_name_label : Label = $PlayerNameLabel
@onready var score_label : Label = $ScoreLabel


func set_portrait(new_texture : Texture):
	portrait.texture = new_texture

func set_player_name(new_name : String):
	player_name_label.text = new_name

func set_score(new_score : int):
	score_label.text = "Score: %d" % new_score
