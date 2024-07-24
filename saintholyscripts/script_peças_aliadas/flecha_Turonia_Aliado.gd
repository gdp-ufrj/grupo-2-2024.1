extends peça

var path : String = "res://scenes/peças_aliadas/flecha_Turonia_Aliado.tscn"

func _init():
	nome = "Flecha de Turônia"
	bonus_tipo = "💧"
	habilidade_txt = "Carrega um poderoso tiro metálico com seu arco que atravessa todos os oponentes pelo caminho, causando 18💥."
	imagem = preload("res://assets/sprites/tile_0088.png")
	health = 80
	mana_max = 90
	mana = 0
	range = 3
	basic_attack_damage = 12
	ability_damage = 18
	mana_por_hit = 15
	bonus = 30
	is_player_team = true
	classe = "Flecha"

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
	instance.set_timer(1)
	
	if bonus_dmg:
		bonus_skill_effect()
	else:
		skill_effect()
	
	add_child(instance)
	
	for x in 10:
		await get_tree().create_timer(0.08).timeout
		instance.global_position -= diff

func bonus_skill_effect():
	instance.set_damage(ability_damage)
	mana = 30
