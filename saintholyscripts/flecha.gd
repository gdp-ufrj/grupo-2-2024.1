extends peça

func _ready():
	health = 80
	mana_max = 70
	mana = 60
	range = 3
	basic_attack_damage = 12
	ability_damage = 20
	mana_por_hit = 10
	bonus = 0
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
			atribuir_alvo()
		
		if is_moving:
			return
			
		if is_attacking:
			return
			
		move()

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
	instance.global_position -= diff
	instance.set_is_player_team(is_player_team)
	
	if is_player_team && bonus_dmg:
		bonus_skill_effect()
	elif is_player_team == false && enemy_bonus_dmg_randomizer():
		bonus_skill_effect()
	else:
		skill_effect()
	
	add_child(instance)
	
	for x in 10:
		await get_tree().create_timer(0.1).timeout
		instance.global_position -= diff

	await get_tree().create_timer(0.1).timeout
	instance.queue_free()

func bonus_skill_effect():
	instance.set_damage(ability_damage + bonus)
	mana = 30
