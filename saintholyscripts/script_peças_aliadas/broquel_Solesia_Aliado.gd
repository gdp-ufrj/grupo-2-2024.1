extends peça

func _init():
	nome = "Broquel de Solésia"
	bonus_tipo = "💥"
	habilidade_txt = "Incendia o chão à frente com uma cortina de chamas, queimando os oponentes por 3⏱️, causando 5💥 por ⏱️."
	imagem = preload("res://assets/sprites/tile_0096.png")
	health = 120
	mana_max = 100
	mana = 0
	range = 1
	basic_attack_damage = 6
	ability_damage = 5
	mana_por_hit = 25
	bonus = 5
	is_player_team = true
	classe = "Broquel"

func habilidade():
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	instance.set_is_player_team(is_player_team)
	instance.set_timer(3)
	instance.set_is_burn(true)
	
	if bonus_dmg:
		instance.set_damage((ability_damage + bonus) * 3)
	else:
		instance.set_damage(ability_damage * 3)
	
	efeitos.stream = efeito_hab
	efeitos.play()
	add_child(instance)
