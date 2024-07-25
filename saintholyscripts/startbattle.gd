extends Button
@onready var start_battle_warning = $"../StartBattleWarning"
@onready var go_to_select_world_2 = $"../GoToSelectWorld2"
@onready var inventory_bg = $"../Bench/InventoryBG"
@onready var musica = $"../Musica"
@onready var efeitos = $"../Efeitos"
@onready var music_battle = $"../MusicBattle"

var battle_music = preload("res://assets/musicas/Asteria_Batalha_MaisLento.mp3")

func _on_pressed():
	if Global.pieces == 0:
		Global.combat_started = true
		inventory_bg.visible = false
		self.visible = false
		go_to_select_world_2.visible = false
		musica.stream = battle_music
		musica.play()
		music_battle.stop()
		efeitos.play()
	if Global.pieces != 0:
		start_battle_warning.visible = true
		$WarningTimer.start()

func _on_bench_area_exited(area):
	Global.pieces -= 1
	print("Peça saiu. Numero de peças:", Global.pieces/2)


func _on_bench_area_entered(area):
	Global.pieces += 1
	print("Peça entrou. Numero de peças:", Global.pieces/2)


func _on_warning_timer_timeout():
	start_battle_warning.visible = false
