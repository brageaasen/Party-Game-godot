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

func _ready():
	# Connect to the game_data signal
	game_data.connect("field_changed", _on_game_data_field_changed)
	# Initialize the current season
	_on_game_data_field_changed("season", game_data.season)

func _on_game_data_field_changed(field_name, new_value):
	if field_name == "season":
		# If season changes, update the tilemap and emitters
		change_season_textures(new_value)
		print(new_value)

# Define the emitting states for each season
var season_effects = {
	GameData.Season.SUMMER: { "LeavesFalling": false, "Snow/SnowFalling": false, "Rain/RainFalling": false },
	GameData.Season.FALL:   { "LeavesFalling": true,  "Snow/SnowFalling": false, "Rain/RainFalling": false },
	GameData.Season.WINTER: { "LeavesFalling": false, "Snow/SnowFalling": true,  "Rain/RainFalling": false },
	GameData.Season.SPRING: { "LeavesFalling": false, "Snow/SnowFalling": false, "Rain/RainFalling": true }
}

func change_season_textures(new_season):
	if new_season == GameData.Season.RANDOM:
		# Handle random season by picking one at random
		new_season = random_season()

	# Update the season in game_data
	game_data.season = new_season

	# Update emitters for the season
	var effects = season_effects.get(new_season, {})
	for emitter_name in effects.keys():
		var emitter = get_node(emitter_name) # Dynamically access the emitter
		if emitter:
			emitter.emitting = effects[emitter_name]
		else:
			print("Emitter not found:", emitter_name)

	# Update textures for the season
	if not SEASON_TEXTURES.has(new_season):
		print("Error: Season key not found in SEASON_TEXTURES:", new_season)
		return

	var count = 0
	for key in SEASON_TEXTURES[new_season]:
		var texture_path = SEASON_TEXTURES[new_season][key]
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
