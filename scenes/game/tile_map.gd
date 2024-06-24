extends TileMap

const SEASON_TEXTURES = {
	Seasons.SUMMER: {
		0: "res://assets/sprites/tile_sets/Tilesets/Summer/simplified/tileset - simplified transparent.png",
		1: "res://assets/sprites/tile_sets/Tilesets/Summer/texture.png",
		2: "res://assets/sprites/tile_sets/Tilesets/Summer/extras/bridge.png",
		3: "res://assets/sprites/tile_sets/Tilesets/Summer/extras/fence.png",
		4: "res://assets/sprites/tile_sets/Tilesets/Summer/extras/props.png",
		5: "res://assets/sprites/tile_sets/Tilesets/Summer/extras/waterfall - bottom.png",
		6: "res://assets/sprites/tile_sets/Tilesets/Summer/autotiles/autotiles grass-water.png",
		7: "res://assets/sprites/tile_sets/Tilesets/Summer/autotiles/autotiles hill - water2.png",
		8: "res://assets/sprites/tile_sets/Tilesets/Summer/autotiles/autotiles hill - water.png",
		9: "res://assets/sprites/tile_sets/Tilesets/Summer/autotiles/autotiles hill.png"
	},
	Seasons.WINTER: {
		0: "res://assets/sprites/tile_sets/Tilesets/Winter/simplified/tileset - simplified transparent.png",
		1: "res://assets/sprites/tile_sets/Tilesets/Winter/texture.png",
		2: "res://assets/sprites/tile_sets/Tilesets/Winter/extras/bridge.png",
		3: "res://assets/sprites/tile_sets/Tilesets/Winter/extras/fence.png",
		4: "res://assets/sprites/tile_sets/Tilesets/Winter/extras/props.png",
		5: "res://assets/sprites/tile_sets/Tilesets/Winter/extras/waterfall - bottom.png",
		6: "res://assets/sprites/tile_sets/Tilesets/Winter/autotiles/autotiles grass-water.png",
		7: "res://assets/sprites/tile_sets/Tilesets/Winter/autotiles/autotiles hill - water2.png",
		8: "res://assets/sprites/tile_sets/Tilesets/Winter/autotiles/autotiles hill - water.png",
		9: "res://assets/sprites/tile_sets/Tilesets/Winter/autotiles/autotiles hill.png"
	},
	Seasons.SPRING: {
		0: "res://assets/sprites/tile_sets/Tilesets/Spring/simplified/tileset - simplified transparent.png",
		1: "res://assets/sprites/tile_sets/Tilesets/Spring/texture.png",
		2: "res://assets/sprites/tile_sets/Tilesets/Spring/extras/bridge.png",
		3: "res://assets/sprites/tile_sets/Tilesets/Spring/extras/fence.png",
		4: "res://assets/sprites/tile_sets/Tilesets/Spring/extras/props.png",
		5: "res://assets/sprites/tile_sets/Tilesets/Spring/extras/waterfall - bottom.png",
		6: "res://assets/sprites/tile_sets/Tilesets/Spring/autotiles/autotiles grass-water.png",
		7: "res://assets/sprites/tile_sets/Tilesets/Spring/autotiles/autotiles hill - water2.png",
		8: "res://assets/sprites/tile_sets/Tilesets/Spring/autotiles/autotiles hill - water.png",
		9: "res://assets/sprites/tile_sets/Tilesets/Spring/autotiles/autotiles hill.png"
	},
	Seasons.FALL: {
		0: "res://assets/sprites/tile_sets/Tilesets/Fall/simplified/tileset - simplified transparent.png",
		1: "res://assets/sprites/tile_sets/Tilesets/Fall/texture.png",
		2: "res://assets/sprites/tile_sets/Tilesets/Fall/extras/bridge.png",
		3: "res://assets/sprites/tile_sets/Tilesets/Fall/extras/fence.png",
		4: "res://assets/sprites/tile_sets/Tilesets/Fall/extras/props.png",
		5: "res://assets/sprites/tile_sets/Tilesets/Fall/extras/waterfall - bottom.png",
		6: "res://assets/sprites/tile_sets/Tilesets/Fall/autotiles/autotiles grass-water.png",
		7: "res://assets/sprites/tile_sets/Tilesets/Fall/autotiles/autotiles hill - water2.png",
		8: "res://assets/sprites/tile_sets/Tilesets/Fall/autotiles/autotiles hill - water.png",
		9: "res://assets/sprites/tile_sets/Tilesets/Fall/autotiles/autotiles hill.png"
	},
}

enum Seasons {
	SUMMER,
	WINTER,
	SPRING,
	FALL
}

@export var season : Seasons

@onready var tile_map = $"."
@onready var leaves_falling = $LeavesFalling
@onready var snow_falling = $Snow/SnowFalling
@onready var rain_falling = $Rain/RainFalling

func _ready():
	# Randomly select a season
	var random_season = Seasons.values()[randi() % Seasons.values().size()]
	change_season_textures(random_season)
func change_season_textures(season):
	# Foliage
	if season == Seasons.FALL:
		print("fall")
		leaves_falling.emitting = true
	elif season == Seasons.WINTER:
		snow_falling.emitting = true
	elif season == Seasons.SPRING:
		rain_falling.emitting = true
	
	var count = 0
	for key in SEASON_TEXTURES[season]:
		var texture_path = SEASON_TEXTURES[season][key]
		var texture = load(texture_path)
		if texture:
			if tile_map.tile_set.has_source(count):
				var tile_source = tile_map.tile_set.get_source(count)
				if tile_source:
					tile_source.texture = texture
			count += 1
		else:
			print("Error loading texture:", texture_path)

