extends peça

func _init():
	health = 100
	mana_max = 90
	mana = 0
	range = 2
	basic_attack_damage = 8
	ability_damage = 10
	mana_por_hit = 30
	bonus = 6
	is_player_team = false
	classe = "Cajado"

func habilidade():
	var diff = global_position - peça_alvo.global_position
	
	if diff.x > 0 and diff.y == 0:
		diff = Vector2(16, 0)
	elif diff.x < 0 and diff.y == 0:
		diff = Vector2(-16, 0)
	elif diff.x == 0 and diff.y > 0:
		diff = Vector2(0, 16)
	elif diff.x == 0 and diff.y < 0:
		diff = Vector2(0, -16)
		
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	instance.set_is_player_team(is_player_team)
	instance.set_timer(0.1)
	
	if enemy_bonus_dmg_randomizer():
		bonus_skill_effect()
	else:
		skill_effect()
	
	efeitos.stream = efeito_hab
	efeitos.play()
	add_child(instance)
	await get_tree().create_timer(0.001).timeout
	instance.global_position -= diff
	await get_tree().create_timer(0.001).timeout
	instance.global_position -= diff
