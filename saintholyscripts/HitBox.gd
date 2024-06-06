extends Area2D

@onready var timer = $Timer

var damage: int
var is_player_team: bool
var is_burn: bool = false
var time: float

func _ready():
	timer.start(time)

func set_damage(_damage):
	damage = _damage
	
func set_is_player_team(_is_player_team):
	is_player_team = _is_player_team

func set_is_burn(_is_burn):
	is_burn = _is_burn
	
func set_timer(_time):
	time = _time

func _on_timer_timeout():
	queue_free()
