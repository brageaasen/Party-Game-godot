extends Control

@onready var card : TextureRect = $Card
@onready var border : TextureRect = $Border
@onready var portrait : TextureRect = $Border/Portrait
@onready var player_name : Label = $Name
@onready var score_label : Label = $Score


const GOLD_CARD = preload("res://assets/ui/leaderboard/gold_card.png")
const GOLD_BORDER = preload("res://assets/ui/leaderboard/gold_border.png")

const SILVER_CARD = preload("res://assets/ui/leaderboard/silver_card.png")
const SILVER_BORDER = preload("res://assets/ui/leaderboard/silver_border.png")

const BRONZE_CARD = preload("res://assets/ui/leaderboard/bronze_card.png")
const BRONZE_BORDER = preload("res://assets/ui/leaderboard/bronze_border.png")

enum CardType {
	GOLD,
	SILVER,
	BRONZE,
}

func set_portrait(new_texture : Texture):
	portrait.texture = new_texture

# Set card and border to the correct type according to input "type"
func set_card_type(type : CardType):
	match type:
		CardType.GOLD:
			card.texture = GOLD_CARD
			border.texture = GOLD_BORDER
		CardType.SILVER:
			card.texture = SILVER_CARD
			border.texture = SILVER_BORDER
		CardType.BRONZE:
			card.texture = BRONZE_CARD
			border.texture = BRONZE_BORDER

func set_card_name(new_name : String):
	player_name.text = new_name

func set_card_score(new_score : int):
	score_label.text = "Score: %d" % new_score
