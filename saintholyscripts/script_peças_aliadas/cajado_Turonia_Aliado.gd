extends peça

var path : String = "res://scenes/peças_aliadas/cajado_Turonia_Aliado.tscn"

func _init():
	nome = "Cajado de Turônia"
	bonus_tipo = "💥"
	habilidade_txt = "Estende a ponta de sua lança com ferro para provocar uma precisa estocada de 3🏹 à sua frente, causando 10💥."
	imagem = preload("res://assets/sprites/tile_0084.png")
	health = 90
	mana_max = 90
	mana = 0
	range = 2
	basic_attack_damage = 8
	ability_damage = 10
	mana_por_hit = 30
	bonus = 8
	is_player_team = true
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
	
	if bonus_dmg:
		bonus_skill_effect()
	else:
		skill_effect()
	
	add_child(instance)
	await get_tree().create_timer(0.001).timeout
	instance.global_position -= diff
	await get_tree().create_timer(0.001).timeout
	instance.global_position -= diff
