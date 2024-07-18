extends Control
@onready var page_1 = $Page1
@onready var page_2 = $Page2
@onready var next_button = $NextButton
@onready var back_button = $BackButton


var standart_color
var another_color
var page :=0
var credits_read:= false


func _ready():
	page = 1



func _on_timer_timeout():
	print("alo")


func _on_next_button_pressed():
	if page == 1:
		show_page2()
		back_button.visible = true
		credits_read = true
	elif page == 2:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_back_button_pressed():
	if page == 2:
		show_page1()
	elif page == 1:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")

func show_page1():
	page_1.visible = true
	page_2.visible = false
	page = 1
	
func show_page2():
	page_1.visible = false
	page_2.visible = true
	page = 2
