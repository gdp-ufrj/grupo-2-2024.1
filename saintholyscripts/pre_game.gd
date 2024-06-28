extends Control


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_world_1_button_down():
	get_tree().change_scene_to_file("res://scenes/arena.tscn")
	
