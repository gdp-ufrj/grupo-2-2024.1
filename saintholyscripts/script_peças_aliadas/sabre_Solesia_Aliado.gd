extends peça

func _init():
	nome = "Sabre de Solésia"
	bonus_tipo = "💥"
	habilidade_txt = "Faz arder sua lâmina para causar queimaduras severas no oponente por 2⏱️, causando 10💥 por ⏱️."
	imagem = preload("res://assets/sprites/tile_0098.png")
	health = 90
	mana_max = 100
	mana = 0
	range = 1
	basic_attack_damage = 10
	ability_damage = 10
	mana_por_hit = 25
	bonus = 2
	is_player_team = true
	classe = "Sabre"

func habilidade():
	efeitos.stream = efeito_hab
	efeitos.play()
	
	if bonus_dmg:
		peça_alvo.queimar((ability_damage + bonus) * 2, 2)
	else:
		peça_alvo.queimar(ability_damage * 2, 2)
