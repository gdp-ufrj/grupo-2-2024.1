extends peça

var basic_cont : int = 0
var habilidade_on : bool = false
var bonux : bool = false

func _init():
	nome = "Flecha de Solésia"
	bonus_tipo = "💥"
	habilidade_txt = "Incandesce sua pistola dobrando a velocidade dos próximos 4 disparos."
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
	bonux = false
	
	if bonus_dmg:
		basic_attack_damage += 4
		bonux = true
	
	efeitos.stream = efeito_hab
	efeitos.play()	
	attack_speed *= 2
	habilidade_on = true
	timer_speed = 1 / attack_speed
	timer.start(timer_speed)


func _on_timer_timeout():
	if basic_cont == 2:
		basic_cont = 0
		attack_speed /= 2
		habilidade_on = false
		if bonux:
			basic_attack_damage -= 4
	
	timer_speed = 1 / attack_speed
	timer.start(timer_speed)
	
	if mana == mana_max:
		if is_player_team:
			skill_timer.start()
			glow_before_qte.emitting = false
			_quick_time_event()
		else:
			ability()
	else:
		if habilidade_on:
			basic_cont += 1
		basic_attack()

func basic_attack():
	var dist_x = abs(global_position.x - peça_alvo.global_position.x);
	var dist_y = abs(global_position.y - peça_alvo.global_position.y);
	
	if (dist_x != 0 and dist_y != 0) or (dist_x == 0 and dist_y > range * 16) or (dist_x > range * 16 and dist_y == 0):
		is_attacking = false
		timer.stop()
		atribuir_alvo()
		return
	
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	instance.set_damage(basic_attack_damage)
	instance.set_is_player_team(is_player_team)
	instance.set_timer(0.1)
	add_child(instance)
	if habilidade_on == false:
		mana = min(mana_max, mana + mana_por_hit)
		hp_bar._set_mana(mana)
