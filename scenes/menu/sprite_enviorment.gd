extends Node2D

@export var summer_enviorment : Node2D
@export var spring_enviorment : Node2D
@export var winter_enviorment : Node2D
@export var fall_enviorment : Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	disable_enviorment_sprites()


func enable_enviorment_sprites(season):
	match season:
		GameData.Season.SUMMER:
			summer_enviorment.visible = true
		GameData.Season.SPRING:
			spring_enviorment.visible = true
		GameData.Season.WINTER:
			winter_enviorment.visible = true
		GameData.Season.FALL:
			fall_enviorment.visible = true

func disable_enviorment_sprites():
	summer_enviorment.visible = false
	spring_enviorment.visible = false
	winter_enviorment.visible = false
	fall_enviorment.visible = false
