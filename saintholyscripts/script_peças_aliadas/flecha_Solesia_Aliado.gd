extends peça

func _init():
	nome = "Flecha de Solesia"
	bonus_tipo = "💥"
	habilidade_txt = "Incandesce sua pistola dobrando a velocidade dos disparos por 2⏱️."
	imagem = preload("res://assets/sprites/tile_0085.png")
	health = 70
	mana_max = 100
	mana = 0
	range = 4
	basic_attack_damage = 10
	ability_damage = 10
	mana_por_hit = 25
	bonus = 4
	is_player_team = true
	classe = "Flecha"

func habilidade():
	var bonux = false
	
	if bonus_dmg:
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
