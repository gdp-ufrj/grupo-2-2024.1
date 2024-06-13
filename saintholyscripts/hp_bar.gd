extends ProgressBar

@onready var mp_bar = $Mp_bar

var health = 0 : set = _set_heath
var mana = 0

func _set_heath(new_heath):
	health = min(max_value, new_heath)
	value = health
	
	if health <= 0:
		queue_free()


func _set_mana(mana):
	mana = mana
	mp_bar.value = mana
	

func init_health_and_mana(_health, _mana_max, _mana, is_player_team):
	health = _health
	max_value = health
	value = health
	mp_bar.max_value = _mana_max
	mp_bar.value = _mana
	if is_player_team == false:
		var sb = StyleBoxFlat.new()
		add_theme_stylebox_override("fill", sb)
		sb.bg_color = Color("ff0000")
