extends Control
@onready var music_standart = $MusicStandart


func _ready():
	music_standart.play(Global.music_progress)
	
func _on_start_pressed():
	get_music_standart_music_progress()
	get_tree().change_scene_to_file("res://scenes/tropas_iniciais.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_creditos_pressed():
	get_music_standart_music_progress()
	get_tree().change_scene_to_file("res://scenes/credits.tscn")

func get_music_standart_music_progress():
	Global.music_progress = music_standart.get_playback_position()   
