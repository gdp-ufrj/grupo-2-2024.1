extends Node2D

@onready var go_to_select_world = $"../GoToSelectWorld"
@onready var victory_warning = $"../VictoryWarning"
@onready var defeat_warning = $"../DefeatWarning"
@onready var restart_button = $"../RestartButton"

func _ready():
	Global.game_ended = 0
	Global.despause()
	Global.check_scene()
	Global.init_arena()

func _process(delta):
	Global.process_arena()
	
	if Global.game_ended == 1:
		show_victory()
	if Global.game_ended == 2:
		show_defeat()

func _on_go_to_select_world_pressed():
	get_tree().change_scene_to_file("res://scenes/pre_game.tscn")

func show_pos_battle_button():
	go_to_select_world.visible = true

func show_victory():
	victory_warning.visible = true
	show_pos_battle_button()

func show_defeat():
	defeat_warning.visible = true
	show_pos_battle_button()
	restart_button.visible = true

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
