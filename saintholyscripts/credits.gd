extends Control
@onready var next_page = $NextPage
var standart_color
var another_color

func _ready():
	standart_color = next_page.get_theme_color("font_outline_color")


func _on_next_page_button_up():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_timer_timeout():
	next_page.remove_theme_color_override("font_outline_color")
	next_page.add_theme_color_override("font_outline_color", standart_color)
	print("alo")
