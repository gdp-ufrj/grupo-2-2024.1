extends peça

func _ready():
	health = 70
	mana_max = 100
	mana = 0
	range = 4
	basic_attack_damage = 10
	ability_damage = 10
	mana_por_hit = 25
	bonus = 4
	
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
	var bonux = false
	
	if is_player_team && bonus_dmg:
		basic_attack_damage += 4
		bonux = true
	elif is_player_team == false && enemy_bonus_dmg_randomizer():
		basic_attack_damage += 4
		bonux = true
		
	attack_speed *= 2
	await get_tree().create_timer(2).timeout
	attack_speed /= 2
	
	if bonux:
		basic_attack_damage -= 4
	
func _on_timer_timeout():
	timer_speed = 1 / attack_speed
	timer.start(timer_speed)
	
	if mana == mana_max:
		if is_player_team:
			skill_timer.start()
			_quick_time_event()
		else:
			ability()
	else:
		basic_attack()
