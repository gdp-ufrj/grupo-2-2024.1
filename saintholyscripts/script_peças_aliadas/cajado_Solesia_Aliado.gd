extends peça

func _init():
	health = 90
	mana_max = 100
	mana = 0
	range = 3
	basic_attack_damage = 6
	ability_damage = 10
	mana_por_hit = 50
	bonus = 4
	is_player_team = true
	classe = "Cajado"

func habilidade():
	var maior_distancia = 0
	
	peças = get_tree().get_nodes_in_group("peças")
	
	var target_peça
	
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
		
	instance = HIT_BOX.instantiate()
	instance.global_position = target_peça.global_position - global_position
	instance.set_is_player_team(is_player_team)
	instance.set_timer(0.1)
	
	if bonus_dmg:
		bonus_skill_effect()
	else:
		skill_effect()
	
	add_child(instance)
