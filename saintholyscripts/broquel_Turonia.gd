extends peça

func _ready():
	health = 120
	mana_max = 100
	mana = 100
	range = 1
	basic_attack_damage = 6
	ability_damage = 10
	mana_por_hit = 20
	bonus = 8
	
	peças = get_tree().get_nodes_in_group("peças")
	
	hp_bar.init_health_and_mana(health, mana_max, mana)
	
	timer_speed = 1 / attack_speed
	
	if is_player_team:
		direçao = Vector2(0, -16)
	else:
		direçao = Vector2(0, 16)
	
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position
	
	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(
				x + region_position.x,
				y + region_position.y
			)
			
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or not tile_data.get_custom_data("andavel"):
				astar_grid.set_point_solid(tile_position)

func _process(delta):
	if Global.combat_started == false:
		if is_player_team:
			check_drag()
	else:
		if peça_alvo == null:
			is_attacking = false
			timer.stop()
			atribuir_alvo()
		
		if is_moving:
			return
			
		if is_attacking:
			return
			
		move()

func habilidade():
	var maior_distancia = 0
	
	var peça_alvo_anterior = peça_alvo
	
	peças = get_tree().get_nodes_in_group("peças")
	
	for p in peças:
		if p == self:
			continue
		
		if p.is_player_team == !is_player_team:
			var distance = global_position.distance_to(p.global_position)
			if distance > maior_distancia:
				maior_distancia = distance
				peça_alvo = p
			elif distance == maior_distancia:
				if is_player_team:
					if p.global_position.y < peça_alvo.global_position.y:
						peça_alvo = p
					elif p.global_position.x < peça_alvo.global_position.x and p.global_position.y == peça_alvo.global_position.y:
						peça_alvo = p
				else:
					if p.global_position.y > peça_alvo.global_position.y:
						peça_alvo = p
					elif p.global_position.x > peça_alvo.global_position.x and p.global_position.y == peça_alvo.global_position.y:
						peça_alvo = p

	var tile_position = global_position + direçao
	var ocupado: bool = false
		
	for op in occupied_posions:
		if op == tile_map.local_to_map(tile_position) or peça_alvo_anterior.global_position == tile_position:
			ocupado = true
	
	if tile_position.x <= 56 and tile_position.x >= -40 and tile_position.y <= 40 and tile_position.y >= -40 and not ocupado:
		tile_position = global_position - direçao
		for op in occupied_posions:
			if op == tile_map.local_to_map(tile_position) or peça_alvo_anterior.global_position == tile_position:
				ocupado = true
		if ocupado:
			tile_position = global_position + Vector2(direçao.y, direçao.x)
		for op in occupied_posions:
			if op == tile_map.local_to_map(tile_position) or peça_alvo_anterior.global_position == tile_position:
				ocupado = true
		if ocupado:
			tile_position = global_position - Vector2(direçao.y, direçao.x)
	
	peça_alvo.global_position = tile_position
	
	
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	instance.set_is_player_team(is_player_team)
	
	if is_player_team && bonus_dmg:
		bonus_skill_effect()
	elif is_player_team == false && enemy_bonus_dmg_randomizer():
		bonus_skill_effect()
	else:
		skill_effect()
	
	add_child(instance)
	await get_tree().create_timer(0.1).timeout
	instance.queue_free()
