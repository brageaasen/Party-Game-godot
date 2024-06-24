class_name PlayerControls
extends  Resource

@export var move_left := "p1_move_left"
@export var move_right := "p1_move_right"
@export var move_up := "p1_move_up"
@export var move_down := "p1_move_down"
@export var run := "p1_run"
@export var jump := "p1_jump"
@export var sit_down := "p1_sit_down"
@export var lay_down := "p1_lay_down"
@export var grab := "p1_grab"


func new_controller(player_id : int):
	move_left = "p" + str(player_id) + "_move_left"
	move_right = "p" + str(player_id) + "_move_right"
	move_up = "p" + str(player_id) + "_move_up"
	move_down = "p" + str(player_id) +"_move_down"
	run = "p" + str(player_id) + "_run"
	jump = "p" + str(player_id) + "_jump"
	sit_down = "p" + str(player_id) + "_sit_down"
	lay_down = "p" + str(player_id) + "_lay_down"
	grab = "p" + str(player_id) + "_grab"
