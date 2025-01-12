extends Control

@export var current_players : CurrentPlayers
@onready var gold_card : Control = $Cards/PlayerEntryGold
@onready var silver_card : Control = $Cards/PlayerEntrySilver
@onready var bronze_card : Control = $Cards/PlayerEntryBronze

# Redefined the CardType enum
enum CardType {
	GOLD,
	SILVER,
	BRONZE,
}

func _ready():
	gold_card.visible = false
	silver_card.visible = false
	bronze_card.visible = false

# Updates the leaderboard
func update_leaderboard():
	if not current_players:
		return
	
	# Fetch all players and sort them by score in descending order
	var players_list = current_players.players.values()
	players_list.sort_custom(_sort_by_score_desc)

	# Update the cards with the top 3 players
	if players_list.size() > 0:
		_update_card(gold_card, players_list[0], gold_card.CardType.GOLD)
	if players_list.size() > 1:
		_update_card(silver_card, players_list[1], silver_card.CardType.SILVER)
	if players_list.size() > 2:
		_update_card(bronze_card, players_list[2], bronze_card.CardType.BRONZE)

# Helper function to sort players by score in descending order
func _sort_by_score_desc(a, b):
	return a.score > b.score

# Helper function to update a card with player data
func _update_card(card: Control, player: PlayerData, card_type: CardType):
	card.visible = true
	card.set_card_type(card_type)
	card.set_card_name(player.name)
	card.set_portrait(player.character)
	print("new score: ", player.score)
	print()
	card.set_card_score(player.score)
