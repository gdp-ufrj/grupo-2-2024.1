extends Control


func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_world_1_button_down():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")


func _on_world_2_button_down():
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")


func _on_world_3_button_down():
	get_tree().change_scene_to_file("res://scenes/levels/level_3.tscn")


func _on_world_4_button_down():
	get_tree().change_scene_to_file("res://scenes/levels/level_4.tscn")


func _on_world_5_button_down():
	get_tree().change_scene_to_file("res://scenes/levels/level_5.tscn")


func _on_world_6_button_down():
	get_tree().change_scene_to_file("res://scenes/levels/level_6.tscn")
