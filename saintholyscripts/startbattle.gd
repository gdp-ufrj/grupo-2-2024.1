extends Button
@onready var start_battle_warning = $"../StartBattleWarning"


func _on_pressed():
	if Global.pieces == 0:
		Global.combat_started = true
		$"../Bench/ColorRect".visible = false
		self.visible = false
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
