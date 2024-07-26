extends peça

var path : String = "res://scenes/peças_aliadas/broquel_Turonia_Aliado.tscn"

func _init():
	nome = "Broquel de Turônia"
	bonus_tipo = "💥"
	habilidade_txt = "Magnetiza seu escudo, atraindo o oponente mais distante para se chocar contra ele, causando 10💥. Começa o combate com a mana máxima."
	imagem = preload("res://assets/sprites/tile_0087.png")
	health = 140
	mana_max = 100
	mana = 100
	range = 1
	basic_attack_damage = 8
	ability_damage = 10
	mana_por_hit = 20
	bonus = 8
	is_player_team = true
	classe = "Broquel"

func habilidade():
	var maior_distancia = 0
	
	var target_peça
	
	peças = get_tree().get_nodes_in_group("peças")
	
	for p in peças:
		
		if p == self or p == peça_alvo:
			continue
			
		occupied_posions.append(tile_map.local_to_map(p.global_position))
	
	for p in peças:
		if p == self:
			continue
		
		if p.is_player_team == !is_player_team:
			var distance = global_position.distance_to(p.global_position)
			if distance > maior_distancia:
				maior_distancia = distance
				target_peça = p
			elif distance == maior_distancia:
				if is_player_team:
					if p.global_position.y < target_peça.global_position.y:
						target_peça = p
					elif p.global_position.x < target_peça.global_position.x and p.global_position.y == target_peça.global_position.y:
						target_peça = p
				else:
					if p.global_position.y > target_peça.global_position.y:
						target_peça = p
					elif p.global_position.x > target_peça.global_position.x and p.global_position.y == target_peça.global_position.y:
						target_peça = p

	var tile_position = global_position + direçao
	var ocupado: bool = false
		
	for op in occupied_posions:
		if op == tile_map.local_to_map(tile_position) or peça_alvo.global_position == tile_position:
			ocupado = true
	
	if (tile_position.x > 56 or tile_position.x < -40 or tile_position.y > 40 or tile_position.y < -40) or ocupado:
		tile_position = global_position - direçao
		ocupado = false
		for op in occupied_posions:
			if op == tile_map.local_to_map(tile_position) or peça_alvo.global_position == tile_position:
				ocupado = true
		if (tile_position.x > 56 or tile_position.x < -40 or tile_position.y > 40 or tile_position.y < -40) or ocupado:
			tile_position = global_position + Vector2(direçao.y, direçao.x)
			ocupado = false
		for op in occupied_posions:
			if op == tile_map.local_to_map(tile_position) or peça_alvo.global_position == tile_position:
				ocupado = true
		if (tile_position.x > 56 or tile_position.x < -40 or tile_position.y > 40 or tile_position.y < -40) or ocupado:
			tile_position = global_position - Vector2(direçao.y, direçao.x)
	
	target_peça.global_position = tile_position
	
	occupied_posions = []
	
	instance = HIT_BOX.instantiate()
	instance.global_position = target_peça.global_position - global_position
	instance.set_is_player_team(is_player_team)
	instance.set_timer(0.1)
	
	if bonus_dmg:
		bonus_skill_effect()
	else:
		skill_effect()
	
	efeitos.stream = efeito_hab
	efeitos.play()
	add_child(instance)
