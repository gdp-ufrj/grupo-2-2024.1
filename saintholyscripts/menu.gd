extends Control
@onready var music_standart = $MusicStandart

func _ready():
	music_standart.play(Global.music_progress)
	
func _on_start_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_music_standart_music_progress()
	if Global.jogo_iniciado:
		get_tree().change_scene_to_file("res://scenes/pre_game.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/tropas_iniciais.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_creditos_pressed():
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_music_standart_music_progress()
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func get_music_standart_music_progress():
	Global.music_progress = music_standart.get_playback_position()   


func _on_reset_pressed():
	Global.resetar_jogo()
