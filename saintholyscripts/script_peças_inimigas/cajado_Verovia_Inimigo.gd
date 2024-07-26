extends peça

func _init():
	health = 100
	mana_max = 90
	mana = 75
	range = 2
	basic_attack_damage = 12
	ability_damage = 15
	mana_por_hit = 15
	bonus = 5
	is_player_team = false
	classe = "Cajado"

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
	
	var tile_position
	var ocupado: bool = false
	
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	instance.set_is_player_team(is_player_team)
	instance.set_timer(0.1)
	
	if enemy_bonus_dmg_randomizer():
		bonus_skill_effect()
	else:
		skill_effect()
	
	add_child(instance)
	
	efeitos.stream = efeito_hab
	efeitos.play()
	for x in 3:
		tile_position = peça_alvo.global_position - diff
		for op in occupied_posions:
			if op == tile_map.local_to_map(tile_position):
				ocupado = true
		if tile_position.x <= 56 and tile_position.x >= -40 and tile_position.y <= 40 and tile_position.y >= -40 and not ocupado:
			peça_alvo.global_position = tile_position
			await get_tree().create_timer(0.08333).timeout
	
	occupied_posions = []

func bonus_skill_effect():
	instance.set_damage(ability_damage + bonus)
	mana = 30
	hp_bar._set_mana(mana)
