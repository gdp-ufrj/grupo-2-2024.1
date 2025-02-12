extends peça

func _init():
	health = 90
	mana_max = 100
	mana = 0
	range = 1
	basic_attack_damage = 10
	ability_damage = 20
	mana_por_hit = 25
	bonus = 10
	is_player_team = false
	classe = "Sabre"

func habilidade():
	peças = get_tree().get_nodes_in_group("peças")
	
	for p in peças:
		if p == self or p == peça_alvo:
			continue
			
		occupied_posions.append(tile_map.local_to_map(p.global_position))
		
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
	
	var tile_position = peça_alvo.global_position - diff
	var ocupado: bool = false
	
	for op in occupied_posions:
		if op == tile_map.local_to_map(tile_position):
			ocupado = true
	
	if tile_position.x <= 56 and tile_position.x >= -40 and tile_position.y <= 40 and tile_position.y >= -40 and not ocupado:
		instance.global_position = global_position - peça_alvo.global_position
		global_position = tile_position
		
	occupied_posions = []
	
	efeitos.stream = efeito_hab
	efeitos.play()
	add_child(instance)
