class_name GameData
extends Resource

@export var difficulty : Difficulty = Difficulty.NORMAL
@export var season : Season = Season.SUMMER

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
