extends Button
@onready var start_battle_warning = $"../StartBattleWarning"

var pieces:= 0
func _on_pressed():
	if pieces == 0:
		Global.combat_started = true
		$"../Bench/ColorRect".visible = false
		self.visible = false
	if pieces != 0:
		start_battle_warning.visible = true
		$WarningTimer.start()

func _on_bench_area_exited(area):
	pieces -= 1
	print("Peça saiu. Numero de peças:", pieces/2)


func _on_bench_area_entered(area):
	pieces += 1
	print("Peça entrou. Numero de peças:", pieces/2)


func _on_warning_timer_timeout():
	start_battle_warning.visible = false
