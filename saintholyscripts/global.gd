extends Node

var banco = []
var Menu = preload("res://scenes/menu.tscn")

var jogo_iniciado : bool = false
var protagonista_nome : String
var current_scene
var combat_started:= false
var is_dragging = false
var combat_ended = false
var player_team_winner : bool
var pieces:= 0
var someone_is_dragging:= false
var game_ended := 0
var arena_started := false

var muted:= false
var pause_on:= false
var music_progress = 0.0
var troops_first_run:= true
var pre_game_runned_before:= false

var num_broquel_ali : int = 0
var num_flecha_ali : int = 0
var num_sabre_ali : int = 0
var num_cajado_ali : int = 0
var num_broquel_ini : int = 0
var num_flecha_ini : int = 0
var num_sabre_ini : int = 0
var num_cajado_ini : int = 0

func _ready():
	pass
	#banco.append("res://scenes/peças_aliadas/sabre_Turonia_Aliado.tscn")
	#banco.append("res://scenes/peças_aliadas/broquel_Turonia_Aliado.tscn")
	#banco.append("res://scenes/peças_aliadas/flecha_Turonia_Aliado.tscn")
	#banco.append("res://scenes/peças_aliadas/cajado_Turonia_Aliado.tscn")

func check_scene():
	current_scene = get_tree().current_scene.name
	return current_scene

func init_arena():
	var peças = get_tree().get_nodes_in_group("peças")
	
	reset_bonus_peca()
	
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
		
	arena_started = true
	
	print("Broquels aliados: ", num_broquel_ali)
	print("Flechas aliados: ", num_flecha_ali)
	print("Sabres aliados: ", num_sabre_ali)
	print("Cajados aliados: ", num_cajado_ali)

func process_arena():
	var peças = get_tree().get_nodes_in_group("peças")
	var time_player = []
	var time_NPC = []
	for p in peças:
		if p.is_player_team:
			time_player.append(p)
		else:
			time_NPC.append(p)
	#print("Time inimigo:",time_NPC.size())
	#print("Time aliado:", time_player.size())
	if time_NPC.size() == 0:
		#print("Você Ganhou!")
		game_ended = 1
		combat_started = false
		get_tree().paused = true
	elif time_player.size() == 0:
		#print("Você Perdeu!")
		combat_started = false
		game_ended = 2
		get_tree().paused = true

func despause():
	get_tree().paused = false
	
func reset_bonus_peca():
	num_broquel_ali = 0
	num_flecha_ali = 0
	num_sabre_ali = 0
	num_cajado_ali = 0
	
func resetar_jogo():
	Global.banco = []
	Global.jogo_iniciado = false
