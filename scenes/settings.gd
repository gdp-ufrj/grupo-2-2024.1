extends Control

@export var bus_name : String
@onready var check_box = $CheckBox

var bus_index: int

func _ready():
	if Global.muted == true:
		check_box.button_pressed = true
	else:
		check_box.button_pressed = false

func _process(delta):
	pass

func _on_check_box_toggled(toggled_on):
	AudioServer.set_bus_mute(0,toggled_on)
	Global.muted = toggled_on


func _on_quit_button_pressed():
	get_tree().quit()


func _on_go_back_button_pressed():
	self.queue_free()
