extends Control

@onready var resize_tournament_timer = $"Panels&Texts/TournmantPanel/ResizetournamentTimer"
@onready var tournament_panel = $"Panels&Texts/TournamentPanel"
@onready var torneio_title = $"Panels&Texts/TorneioTitle"
@onready var torneio_text = $"Panels&Texts/TorneioText"
@onready var tropas_button = $Buttons/TropasButton
@onready var tutorial_button = $Buttons/TutorialButton
@onready var settings_button = $Buttons/SettingsButton




@onready var torneio_title_resize_timer = $"Panels&Texts/TorneioTitle/TorneioTitleResizeTimer"
@onready var torneio_text_resizer_timer = $"Panels&Texts/TorneioText/TorneioTextResizerTimer"
@onready var resize_tournamant_timer = $"Panels&Texts/TournamentPanel/ResizeTournamantTimer"
@onready var tropas_resize_timer = $Buttons/TropasButton/TropasResizeTimer
@onready var tutorial_resize_timer = $Buttons/TutorialButton/TutorialResizeTimer
@onready var settings_resize_timer = $Buttons/SettingsButton2/SettingsResizeTimer




var tourn
var scale_start_panel = Vector2(0,0)
var scale_start_button =Vector2(0,0)
var scale_start_text=Vector2(0,0)
var tournament_panel_scale = Vector2(0.48,0.48)
var normal_scale = Vector2(1,1)
var tournament_panel_ready:= false
var tropas_button_ready:= false
var tutorial_button_ready:= false
var settings_button_ready:= false
var torneio_title_ready:= false
var torneio_text_ready:= false

var to_go_tropas_button:= false
var to_go_tutorial_button:=false
var to_go_settings_button:=false



func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_world_1_button_down():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

#Coleta um node e aumenta seu tamanho um pouco caso não esteja na escala ideal
func resize(node, node_type, goal_scale):
	if node_type == "button" or node_type == "text":
		if node.get_scale() <= goal_scale:
			scale_start_button += Vector2(0.34,0.34)
			node.set_scale(scale_start_button)
		else:
			scale_start_button = 0
			scale_start_text = 0
			return true
	if node_type == "panel":
		if node.get_scale()<= goal_scale:
			scale_start_panel += Vector2(0.16,0.16)
			node.set_scale(scale_start_panel)
		else:
			scale_start_panel = 0
			return true

#Aqui vão ficar guardados os sinais dos timers de cada node
func _on_resize_tournmant_timer_timeout():
	if tournament_panel.scale == tournament_panel_scale:
		tournament_panel_ready = true
	else:
		resize(tournament_panel, "panel", tournament_panel_scale)


func _on_torneio_title_resize_timer_timeout():
	if tournament_panel_ready:
		if torneio_title.scale >= normal_scale:
			torneio_title_ready = true
			scale_start_button = Vector2(0,0)
			torneio_title_resize_timer.stop()
		else:
			resize(torneio_title,"text", normal_scale)


func _on_torneio_text_resizer_timer_timeout():
	if tournament_panel_ready && torneio_title_ready == true:
		if torneio_text.scale >= normal_scale:
			to_go_tropas_button = true
			scale_start_panel = Vector2(0,0)
			torneio_text_resizer_timer.stop()
		else:
			resize(torneio_text,"text",normal_scale)



func _on_tropas_resize_timer_timeout():
	if to_go_tropas_button == true:
		if tropas_button.scale >= normal_scale:
			to_go_tutorial_button = true
			scale_start_button = Vector2(0,0)
			tropas_resize_timer.stop()
		else:
			resize(tropas_button,"button",normal_scale)
