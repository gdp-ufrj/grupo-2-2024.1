extends Node2D
@onready var timer: Timer = $Player/Timer
@onready var progress_bar: ProgressBar = $Player/Mana
@onready var sprite_2d: Sprite2D = $Player/Sprite2D
@onready var area_2d: Area2D = $Player/Area2D
@onready var glow = $Player/SkillTimeParticles

var bonus_dmg: bool = false
var qte_allowed: bool = false
var mouse_over: bool = false
func _ready():
	timer.stop()

func _process(delta):
	_check_full_mana()
	
func _check_full_mana():
	if progress_bar.value< 100:
		_increase_bar_value()
	else:
		if timer.is_stopped() == true:
			timer.start()
			_quick_time_event()

func _on_timer_timeout():
	progress_bar.value=0
	sprite_2d.flip_v = false
	glow.finished
	if bonus_dmg == true:
		print("Bonus damage!")
		bonus_dmg = false
func _increase_bar_value():
	if timer.is_stopped()==true:
		progress_bar.value+=1
		qte_allowed = false
func _quick_time_event():
	if timer.is_stopped() == false:
		sprite_2d.flip_v = true
		area_2d.visible = true
		qte_allowed = true
		glow.emitting = true

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed && qte_allowed && mouse_over == true:
				bonus_dmg = true
				print("clicou")

func _on_area_2d_input_event(viewport, event, shape_idx):
	mouse_over = true

func _on_area_2d_mouse_exited():
	mouse_over = false
