class_name GameData
extends Resource

# Signal to notify changes in fields
signal field_changed(field_name, new_value)


const max_players = 9

@export var difficulty: Difficulty = Difficulty.NORMAL:
	set(value):
		if difficulty != value:
			difficulty = value
			emit_signal("field_changed", "difficulty", value)

@export var season: Season = Season.SUMMER:
	set(value):
		if season != value:
			season = value
			emit_signal("field_changed", "season", value)

enum Difficulty {
	EASY,
	NORMAL,
	HARD
}

enum Season {
	RANDOM,
	SUMMER,
	WINTER,
	SPRING,
	FALL
}
