extends peça

var basic_cont : int = 0
var habilidade_on : bool = false
var bonux : bool = false

func _init():
	nome = "Flecha de Solésia"
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
	bonux = false
	
	if bonus_dmg:
		basic_attack_damage += 4
		bonux = true
		
	attack_speed *= 2
	habilidade_on = true


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
