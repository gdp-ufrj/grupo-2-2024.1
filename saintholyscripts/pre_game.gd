extends Control

@onready var tournament_panel = $"Panels&Texts/TournamentPanel"
@onready var resize_tournamant_timer = $"Panels&Texts/TournamentPanel/ResizeTournamantTimer"

@onready var torneio_title = $"Panels&Texts/TorneioTitle"
@onready var torneio_title_resize_timer = $"Panels&Texts/TorneioTitle/TorneioTitleResizeTimer"

@onready var torneio_text = $"Panels&Texts/TorneioText"
@onready var torneio_text_resizer_timer = $"Panels&Texts/TorneioText/TorneioTextResizerTimer"

@onready var tropas_button = $Buttons/TropasButton
@onready var tropas_resize_timer = $Buttons/TropasButton/TropasResizeTimer

@onready var tutorial_button = $Buttons/TutorialButton
@onready var tutorial_resize_timer = $Buttons/TutorialButton/TutorialResizeTimer

@onready var settings_button = $Buttons/SettingsButton
@onready var settings_resize_timer = $Buttons/SettingsButton/SettingsResizeTimer

@onready var world_1 = $Buttons/World1
@onready var world_1_timer = $Buttons/World1/World1Timer

@onready var globo = $"Panels&Texts/Globo"
@onready var globo_resize_timer = $"Panels&Texts/Globo/GloboResizeTimer"

@onready var linha_2 = $"Panels&Texts/Linha2"
@onready var linha_2_resize_timer = $"Panels&Texts/Linha2/Linha2ResizeTimer"


@onready var linha_longa = $"Panels&Texts/LinhaLonga"
@onready var linha_long_resize_timer = $"Panels&Texts/LinhaLonga/LinhaLongResizeTimer"

@onready var linha_1 = $"Panels&Texts/Linha1"
@onready var linha_1_resize_timer = $"Panels&Texts/Linha1/Linha1ResizeTimer"

@onready var dot_level_1 = $"Panels&Texts/DotLevel1"
@onready var dot_level_1_resize_timer = $"Panels&Texts/DotLevel1/DotLevel1ResizeTimer"

@onready var dot_level_2 = $"Panels&Texts/DotLevel2"
@onready var dot_level_2_resize_timer = $"Panels&Texts/DotLevel2/DotLevel2ResizeTimer"

@onready var dot_level_3 = $"Panels&Texts/DotLevel3"
@onready var dot_level_3_resize_timer = $"Panels&Texts/DotLevel3/DotLevel3ResizeTimer"

@onready var locked_level_3 = $"Panels&Texts/LockedLevel3"
@onready var locked_level_3_resize_timer = $"Panels&Texts/LockedLevel3/LockedLevel3ResizeTimer"

@onready var locked_level_2 = $"Panels&Texts/LockedLevel2"
@onready var locked_level_2_resize_timer = $"Panels&Texts/LockedLevel2/LockedLevel2ResizeTimer"
@onready var level_1_stages = $Buttons/Level_1_Stages
@onready var go_back_button = $Buttons/GoBackButton
@onready var stage_1 = $Buttons/Level_1_Stages/Stage_1
@onready var stage_2 = $Buttons/Level_1_Stages/Stage_2
@onready var stage_3 = $Buttons/Level_1_Stages/Stage_3
@onready var stage_4 = $Buttons/Level_1_Stages/Stage_4
@onready var stage_5 = $Buttons/Level_1_Stages/Stage_5
@onready var stage_6 = $Buttons/Level_1_Stages/Stage_6


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
var to_go_to_globe:= false
var to_go_dot_level_3:= false
var to_go_dot_level_2:= false
var to_go_linha_2:=false
var to_go_linha_1:=false
var to_go_locked_level_3:=false
var to_go_linha_longa:=false
var to_go_dot_level_1:=false
var to_go_locked_level_2:= false
var to_go_level_1:= false
var load_complete:= false

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_world_1_button_down():
	level_1_stages.visible = true

func resize(node, node_type, goal_scale):
	#print("resize_called")
	if scale_start_text >= normal_scale:
		scale_start_text = Vector2(0,0)
	if scale_start_panel>= tournament_panel_scale:
		scale_start_panel = Vector2(0,0)
	if scale_start_button>= normal_scale:
		scale_start_button =Vector2(0,0)
	if node_type == "text":
		if node.get_scale() <= goal_scale:
			scale_start_text += Vector2(0.34,0.34)
			node.set_scale(scale_start_text)
		else:
			scale_start_text = 0
			return true
	elif node_type == "button":
		if node.get_scale() <= goal_scale:
			scale_start_button += Vector2(0.2,0.2)
			node.set_scale(scale_start_button)
		else:
			scale_start_text=0
			return true
	elif node_type == "panel":
		if node.get_scale()<= goal_scale:
			scale_start_panel += Vector2(0.16,0.16)
			node.set_scale(scale_start_panel)
		else:
			scale_start_panel = 0
			return true

#Aqui vão ficar guardados os sinais dos timers de cada node
func _on_resize_tournmant_timer_timeout():
	print("timer_called")
	if tournament_panel.scale == tournament_panel_scale:
		tournament_panel_ready = true
		torneio_title_resize_timer.start()
		resize_tournamant_timer.stop()
	else:
		resize(tournament_panel, "panel", tournament_panel_scale)


func _on_torneio_title_resize_timer_timeout():
	print("timer_called")
	if tournament_panel_ready:
		if torneio_title.scale >= normal_scale:
			torneio_title_ready = true
			torneio_text_resizer_timer.start()
			scale_start_button = Vector2(0,0)
			torneio_title_resize_timer.stop()
		else:
			resize(torneio_title,"text", normal_scale)


func _on_torneio_text_resizer_timer_timeout():
	print("timer_called")
	if tournament_panel_ready && torneio_title_ready == true:
		if torneio_text.scale >= normal_scale:
			to_go_tropas_button = true
			tropas_resize_timer.start()
			scale_start_panel = Vector2(0,0)
			torneio_text_resizer_timer.stop()
		else:
			resize(torneio_text,"text",normal_scale)



func _on_tropas_resize_timer_timeout():
	print("timer_called")
	if to_go_tropas_button == true:
		if tropas_button.scale >= normal_scale:
			to_go_tutorial_button = true
			tutorial_resize_timer.start()
			scale_start_button = Vector2(0,0)
			tropas_resize_timer.stop()
		else:
			resize(tropas_button,"button",normal_scale)


func _on_tutorial_resize_timer_timeout():
	print("timer_called")
	if to_go_tutorial_button == true:
		if tutorial_button.scale >= normal_scale:
			to_go_settings_button = true
			settings_resize_timer.start()
			scale_start_button = Vector2(0,0)
			tutorial_resize_timer.stop()
		else:
			resize(tutorial_button,"button",normal_scale)


func _on_settings_resize_timer_timeout():
	print("timer_called")
	if to_go_settings_button == true:
		if settings_button.scale >= normal_scale:
			to_go_to_globe = true
			globo_resize_timer.start()
			scale_start_button = Vector2(0,0)
			settings_resize_timer.stop()
		else:
			resize(settings_button,"button",normal_scale)


func _on_globo_resize_timer_timeout():
	print("timer_called")
	if to_go_to_globe == true:
		if globo.scale >= tournament_panel_scale:
			to_go_dot_level_3 = true
			dot_level_3_resize_timer.start()
			globo_resize_timer.stop()
		else:
			resize(globo,"panel",tournament_panel_scale)
	


func _on_dot_level_3_resize_timer_timeout():
	print("timer_called")
	if to_go_dot_level_3 == true:
		if dot_level_3.scale >= tournament_panel_scale:
			to_go_dot_level_2 = true
			dot_level_2_resize_timer.start()
			dot_level_3_resize_timer.stop()
		else:
			resize(dot_level_3,"panel",tournament_panel_scale)




func _on_dot_level_2_resize_timer_timeout():
	print("timer_called")
	if to_go_dot_level_2 == true:
		if dot_level_2.scale >= tournament_panel_scale:
			to_go_linha_2 = true
			linha_2_resize_timer.start()
			dot_level_2_resize_timer.stop()
		else:
			resize(dot_level_2,"panel",tournament_panel_scale)


func _on_linha_2_resize_timer_timeout():
	print("timer_called")
	if to_go_linha_2 == true:
		if linha_2.scale >= tournament_panel_scale:
			to_go_linha_1 = true
			linha_1_resize_timer.start()
			linha_2_resize_timer.stop()
		else:
			resize(linha_2,"panel",tournament_panel_scale)


func _on_linha_1_resize_timer_timeout():
	print("timer_called")
	if to_go_linha_1 == true:
		if linha_1.scale >= tournament_panel_scale:
			to_go_locked_level_3 = true
			locked_level_3_resize_timer.start()
			linha_1_resize_timer.stop()
		else:
			resize(linha_1,"panel",tournament_panel_scale)

func _on_locked_level_3_resize_timer_timeout():
	print("timer_called")
	if to_go_locked_level_3 == true:
		if locked_level_3.scale >= tournament_panel_scale:
			to_go_linha_longa = true
			linha_long_resize_timer.start()
			locked_level_3_resize_timer.stop()
		else:
			resize(locked_level_3,"panel",tournament_panel_scale)



func _on_linha_long_resize_timer_timeout():
	print("timer_called")
	if to_go_linha_longa == true:
		if linha_longa.scale >= tournament_panel_scale:
			to_go_dot_level_1 = true
			dot_level_1_resize_timer.start()
			linha_long_resize_timer.stop()
		else:
			resize(linha_longa,"panel",tournament_panel_scale)



func _on_dot_level_1_resize_timer_timeout():
	print("timer_called")
	if to_go_dot_level_1 == true:
		if dot_level_1.scale >= tournament_panel_scale:
			to_go_locked_level_2 = true
			locked_level_2_resize_timer.start()
			dot_level_1_resize_timer.stop()
		else:
			resize(dot_level_1,"panel",tournament_panel_scale)

func _on_locked_level_2_resize_timer_timeout():
	print("timer_called")
	if to_go_locked_level_2 == true:
		if locked_level_2.scale >= tournament_panel_scale:
			to_go_level_1 = true
			world_1_timer.start()
			locked_level_2_resize_timer.stop()
		else:
			resize(locked_level_2,"panel",tournament_panel_scale)



func _on_world_1_timer_timeout():
	print("timer_called")
	if to_go_level_1 == true:
		if world_1.scale >= normal_scale:
			load_complete = true
			world_1_timer.stop()
			unlock_click()
		else:
			resize(world_1,"button",normal_scale)


func _on_tropas_button_pressed():
	get_tree().change_scene_to_file("res://scenes/tropas.tscn")




func _on_stage_1_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func unlock_click():
	if load_complete == true:
		world_1.set_mouse_filter(Control.MOUSE_FILTER_STOP)
		tropas_button.set_mouse_filter(Control.MOUSE_FILTER_STOP)
		tutorial_button.set_mouse_filter(Control.MOUSE_FILTER_STOP)
		settings_button.set_mouse_filter(Control.MOUSE_FILTER_STOP)
		go_back_button.visible = true
		go_back_button.set_mouse_filter(Control.MOUSE_FILTER_STOP)
