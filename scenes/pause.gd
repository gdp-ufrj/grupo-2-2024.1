extends Control

@onready var pause = $"."
@onready var warning_pop_up = $WarningPopUp
@onready var settings_button = $Settings
@onready var main_menu = $MainMenu
@onready var back = $Back
var settings = preload("res://scenes/settings.tscn")



func _on_main_menu_pressed():
	show_warning()
	deactivate_mouse_on_other_buttons()

func show_warning():
	warning_pop_up.visible = true

func hide_warning():
	warning_pop_up.visible = false

func reactivate_mouse_on_onther_buttons():
	settings_button.mouse_filter = 0
	main_menu.mouse_filter = 0
	back.mouse_filter = 0

func deactivate_mouse_on_other_buttons():
	settings_button.mouse_filter = 2
	main_menu.mouse_filter = 2
	back.mouse_filter = 2

func _on_yes_back_menu_pressed():
	get_tree().paused = false
	Global.pause_on = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_no_back_menu_pressed():
	hide_warning()
	reactivate_mouse_on_onther_buttons()

func _on_back_pressed():
	get_tree().paused = false
	Global.pause_on = false
	self.queue_free()


func _on_settings_pressed():
	var instance = settings.instantiate()
	pause.add_child(instance)
