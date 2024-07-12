extends Node2D

@onready var go_to_select_world = $"../GoToSelectWorld"
@onready var victory_warning = $"../VictoryWarning"
@onready var defeat_warning = $"../DefeatWarning"
@onready var restart_button = $"../RestartButton"
@onready var next_level_button = $"../NextLevelButton"
@onready var pickin = $"../Pickin"
@onready var pecas_aliadas = $"../Peças Aliadas"
@onready var pecas_inimigas = $"../Peças Inimigas"
@onready var button_peca1 = $"../Pickin/Button"
@onready var button_peca2 = $"../Pickin/Button2"

var p_inim = []
var p_paths = []
var indice_botoes = []
var current_scene
var rng = RandomNumberGenerator.new()
var erro = false

func _ready():
	init_banco()
	
	Global.game_ended = 0
	Global.despause()
	Global.check_scene()
	Global.init_arena()
	
	current_scene = get_tree().current_scene
	
	p_inim = pecas_inimigas.get_children()
	
	#print(p_inim[0].scene_file_path)
	#print(((p_inim[0].scene_file_path).get_slice("_", 0) + "_aliadas/" + (p_inim[0].scene_file_path).get_slice("/", 4)).left(-12) + "Aliado.tscn")                 
	init_botoes_peca()

func _process(delta):
	Global.process_arena()
	
	if Global.game_ended == 1:
		show_victory()
	if Global.game_ended == 2:
		show_defeat()

func init_banco():
	for i in range(Global.banco.size()):
		var instance = load(Global.banco[i]).instantiate()
		instance.global_position = Vector2(-40 + (16 * i), 80)
		pecas_aliadas.add_child(instance)

func _on_go_to_select_world_pressed():
	get_tree().change_scene_to_file("res://scenes/pre_game.tscn")

func show_pos_battle_button():
	go_to_select_world.visible = true

func show_victory():
	victory_warning.visible = true
	if erro:
		show_pos_battle_button()
		if current_scene.name != "Level 6":
			next_level_button.visible = true
	else:
		pickin.visible = true

func show_defeat():
	defeat_warning.visible = true
	show_pos_battle_button()
	restart_button.visible = true

func _on_restart_button_pressed():
	get_tree().reload_current_scene()
	

func _on_next_level_button_pressed():
	var curr_scene_path = current_scene.scene_file_path
	var next_level_number = curr_scene_path.to_int() + 1
	
	var next_level_path = "res://scenes/levels/level_" + str(next_level_number) + ".tscn"
	get_tree().change_scene_to_file(next_level_path)


func _on_button_pressed():
	show_pos_battle_button()
	if current_scene.name != "Level 6":
		next_level_button.visible = true
	pickin.visible = false
	add_peca_banco(0)

func _on_button_2_pressed():
	show_pos_battle_button()
	if current_scene.name != "Level 6":
		next_level_button.visible = true
	pickin.visible = false
	add_peca_banco(1)

func init_botoes_peca():
	var contador : int = 0
	var ja_foi : int = -1
	var achou : bool = false
	while achou == false and contador < 30:
		contador += 1
		if contador == 30:
			erro = true
		var ja_tem : bool = false
		var rnum = rng.randi_range(0, p_inim.size() - 1)
		for i in range(Global.banco.size() - 1):
			var path = p_inim[rnum].scene_file_path
			path = ((path).get_slice("_", 0) + "_aliadas/" + (path).get_slice("/", 4)).left(-12) + "Aliado.tscn"
			if path == Global.banco[i]:
				ja_tem = true
		if ja_tem == false and rnum != ja_foi:
			indice_botoes.append(rnum)
			ja_foi = rnum
			if indice_botoes.size() == 2:
				achou = true
	
	if achou:
		button_peca1.text = (p_inim[indice_botoes[0]].name).get_slice("_", 0) + " de " + p_inim[indice_botoes[0]].name.get_slice("_", 1)
		button_peca1.icon = p_inim[indice_botoes[0]].find_child("Sprite").get_texture()
		button_peca2.text = (p_inim[indice_botoes[1]].name).get_slice("_", 0) + " de " + p_inim[indice_botoes[1]].name.get_slice("_", 1)
		button_peca2.icon = p_inim[indice_botoes[1]].find_child("Sprite").get_texture()
		
		p_paths.append(p_inim[indice_botoes[0]].scene_file_path)
		p_paths.append(p_inim[indice_botoes[1]].scene_file_path)

func add_peca_banco(indice):
	var path = p_paths[indice]
	path = ((path).get_slice("_", 0) + "_aliadas/" + (path).get_slice("/", 4)).left(-12) + "Aliado.tscn"
	Global.banco.append(path)
