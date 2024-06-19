extends peça

func _init():
	health = 120
	mana_max = 100
	mana = 0
	range = 1
	basic_attack_damage = 12
	ability_damage = 15
	mana_por_hit = 20
	bonus = 10
	is_player_team = false
	classe = "Sabre"

func habilidade():
	peças = get_tree().get_nodes_in_group("peças")
	
	var cura
	
	if enemy_bonus_dmg_randomizer():
		cura = ability_damage + bonus
	else:
		cura = ability_damage
	
	for p in peças:
		if is_player_team == p.is_player_team:
			p.take_damage(-cura)
