extends Node

var combat_started:= false
var is_dragging = false
var combat_ended = false
var player_team_winner : bool
var pieces:= 0
var someone_is_dragging:= false

var num_broquel_ali : int = 0
var num_flecha_ali : int = 0
var num_sabre_ali : int = 0
var num_cajado_ali : int = 0
var num_broquel_ini : int = 0
var num_flecha_ini : int = 0
var num_sabre_ini : int = 0
var num_cajado_ini : int = 0

func _ready():
	var peças = get_tree().get_nodes_in_group("peças")
	
	for p in peças:
		if p.is_player_team:
			if p.classe == "Broquel":
				num_broquel_ali += 1
			elif p.classe == "Flecha":
				num_flecha_ali += 1
			elif p.classe == "Sabre":
				num_sabre_ali += 1
			elif p.classe == "Cajado":
				num_cajado_ali += 1
		else:
			if p.classe == "Broquel":
				num_broquel_ini += 1
			elif p.classe == "Flecha":
				num_flecha_ini += 1
			elif p.classe == "Sabre":
				num_sabre_ini += 1
			elif p.classe == "Cajado":
				num_cajado_ini += 1
	
	print("Broquels aliados: ", num_broquel_ali)
	print("Flechas aliados: ", num_flecha_ali)
	print("Sabres aliados: ", num_sabre_ali)
	print("Cajados aliados: ", num_cajado_ali)
	print("Broquels inimigos: ", num_broquel_ini)
	print("Flechas inimigos: ", num_flecha_ini)
	print("Sabres inimigos: ", num_sabre_ini)
	print("Cajados inimigos: ", num_cajado_ini)

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
