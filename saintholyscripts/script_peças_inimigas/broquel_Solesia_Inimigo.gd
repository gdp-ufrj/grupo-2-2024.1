extends peça

func _init():
	health = 120
	mana_max = 100
	mana = 0
	range = 1
	basic_attack_damage = 6
	ability_damage = 6
	mana_por_hit = 20
	bonus = 6
	is_player_team = false

func habilidade():
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	instance.set_is_player_team(is_player_team)
	instance.set_timer(3)
	instance.set_is_burn(true)
	
	if enemy_bonus_dmg_randomizer():
		bonus_skill_effect()
	else:
		skill_effect()
	
	add_child(instance)
