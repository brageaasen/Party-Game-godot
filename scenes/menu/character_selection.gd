extends Control

var character_to_sprite: Dictionary = {
	"Black": "res://assets/sprites/characters/black_0.png",
	"Blue": "res://assets/sprites/characters/blue_0.png",
	"Brown": "res://assets/sprites/characters/brown_0.png",
	"Calico": "res://assets/sprites/characters/calico_0.png",
	"CottonCandyBlue": "res://assets/sprites/characters/cotton_candy_blue_0.png",
	"CottonCandyPink": "res://assets/sprites/characters/cotton_candy_pink_0.png",
	"Creme": "res://assets/sprites/characters/creme_0.png",
	"Dark": "res://assets/sprites/characters/dark_0.png",
	"GameBoy": "res://assets/sprites/characters/game_boy_0.png",
	"Ghost": "res://assets/sprites/characters/ghost_0.png",
	"Gold": "res://assets/sprites/characters/gold_0.png",
	"Grey": "res://assets/sprites/characters/grey_0.png",
	"Hairless": "res://assets/sprites/characters/hairless_0.png",
	"Indigo": "res://assets/sprites/characters/indigo_0.png",
	"Orange": "res://assets/sprites/characters/orange_0.png",
	"Peach": "res://assets/sprites/characters/peach_0.png",
	"Pink": "res://assets/sprites/characters/pink_0.png",
	"Radioactive": "res://assets/sprites/characters/radioactive_0.png",
	"Red": "res://assets/sprites/characters/red_0.png",
	"SealPoint": "res://assets/sprites/characters/seal_point_0.png",
	"Teal": "res://assets/sprites/characters/teal_0.png",
	"White": "res://assets/sprites/characters/white_0.png",
	"WhiteGrey": "res://assets/sprites/characters/white_grey_0.png",
	"Yellow": "res://assets/sprites/characters/yellow_0.png",
}

# Tracks locked characters (character_name -> player_index)
var locked_characters: Dictionary = {}
