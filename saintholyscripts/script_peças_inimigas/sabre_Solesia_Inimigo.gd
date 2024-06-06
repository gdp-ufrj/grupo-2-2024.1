extends peça

func _init():
	health = 90
	mana_max = 100
	mana = 0
	range = 1
	basic_attack_damage = 10
	ability_damage = 16
	mana_por_hit = 25
	bonus = 4
	is_player_team = false

func habilidade():
	if enemy_bonus_dmg_randomizer():
		peça_alvo.queimar(ability_damage + bonus, 2)
	else:
		peça_alvo.queimar(ability_damage, 2)
