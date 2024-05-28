extends Area2D

var damage: int
var is_player_team: bool
var is_burn: bool = false

func set_damage(_damage):
	damage = _damage
	
func set_is_player_team(_is_player_team):
	is_player_team = _is_player_team

func set_is_burn(_is_burn):
	is_burn = _is_burn
