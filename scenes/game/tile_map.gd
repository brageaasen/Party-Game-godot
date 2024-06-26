extends TileMap

const SEASON_TEXTURES = {
	game_data.Season.SUMMER: {
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
	game_data.Season.WINTER: {
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
	game_data.Season.SPRING: {
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
	game_data.Season.FALL: {
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

@onready var tile_map = $"."
@onready var leaves_falling = $LeavesFalling
@onready var snow_falling = $Snow/SnowFalling
@onready var rain_falling = $Rain/RainFalling

@export var game_data : GameData

func _process(delta):
	#print(game_data.season)
	if game_data.season == game_data.Season.RANDOM:
		# Randomly select a season
		change_season_textures(random_season())
	else:
		# Change to player chosen season
		change_season_textures(game_data.season)

func change_season_textures(new_season):
	game_data.season = new_season
	# Foliage
	if new_season == game_data.Season.FALL:
		leaves_falling.emitting = true
	elif new_season == game_data.Season.WINTER:
		snow_falling.emitting = true
	elif new_season == game_data.Season.SPRING:
		rain_falling.emitting = true
	
	var count = 0
	for key in SEASON_TEXTURES[game_data.season]:
		var texture_path = SEASON_TEXTURES[game_data.season][key]
		var texture = load(texture_path)
		if texture:
			if tile_map.tile_set.has_source(count):
				var tile_source = tile_map.tile_set.get_source(count)
				if tile_source:
					tile_source.texture = texture
			count += 1
		else:
			print("Error loading texture:", texture_path)

func random_season():
	# Get all enum values and filter out the first one (Season.RANDOM)
	var season_values = []
	for value in game_data.Season.values():
		if value != game_data.Season.RANDOM:
			season_values.append(value)
	
	# Select a random season from the filtered list
	var random_index = randi() % season_values.size()
	return season_values[random_index]
