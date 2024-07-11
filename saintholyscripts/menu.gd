extends Control



func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/pre_game.tscn")



func _on_quit_pressed():
	get_tree().quit()

func _on_creditos_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
