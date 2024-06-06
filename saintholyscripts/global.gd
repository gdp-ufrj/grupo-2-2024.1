extends Node

var combat_started:= false
var is_dragging = false
var combat_ended = false
var player_team_winner : bool

func _process(delta):
	var peças = get_tree().get_nodes_in_group("peças")
	var time_player = []
	var time_NPC = []
	
	for p in peças:
		if p.is_player_team:
			time_player.append(p)
		else:
			time_NPC.append(p)
	
	if time_NPC.size() == 0:
		print("Você Ganhou!")
		get_tree().paused = true
	elif time_player.size() == 0:
		print("Você Perdeu!")
		get_tree().paused = true
