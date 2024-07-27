extends Node2D

const BALLOON = preload("res://dialogos/balloon.tscn")

@export var dialogue_resource : DialogueResource = preload("res://dialogos/inicio_fase.dialogue")

@onready var go_to_select_world = $"GoToSelectWorld"
@onready var victory_warning = $"VictoryWarning"
@onready var defeat_warning = $"DefeatWarning"
@onready var restart_button = $"RestartButton"
@onready var next_level_button = $"NextLevelButton"
@onready var pickin = $"Pickin"
@onready var pecas_aliadas = $"Peças Aliadas"
@onready var pecas_inimigas = $"Peças Inimigas"
@onready var button_peca1 = $"Pickin/Button"
@onready var button_peca2 = $"Pickin/Button2"
@onready var efeitos = $"Efeitos"
@onready var musica = $"Musica"
@onready var music_battle = $"MusicBattle"

var pause_menu = preload("res://scenes/pause.tscn")

var efeito_vitoria = preload("res://assets/musicas/vitoria_sfx.mp3")
var efeito_derrota = preload("res://assets/musicas/derrota_sfx.mp3")
var efeito_torcida = preload("res://assets/musicas/Stadium Crowd sfx.mp3")

var p_inim = []
var p_paths = []
var indice_botoes = []
var current_scene
var rng = RandomNumberGenerator.new()

var batalha_acabou : bool = false

func _ready():
	init_banco()
	music_battle.play(Global.music_progress)
	Global.game_ended = 0
	Global.despause()
	Global.check_scene()
	Global.init_arena()
	get_tree().paused = false
	current_scene = get_tree().current_scene
	
	var dialogo: Node = BALLOON.instantiate()
	add_child(dialogo)
	if get_tree().current_scene.name == "Level 1":
		dialogo.start(dialogue_resource, "fase_1_inicio")
	elif get_tree().current_scene.name == "Level 2":
		dialogo.start(dialogue_resource, "fase_2_inicio")
	elif get_tree().current_scene.name == "Level 3":
		dialogo.start(dialogue_resource, "fase_3_inicio")
	elif get_tree().current_scene.name == "Level 4":
		dialogo.start(dialogue_resource, "fase_4_inicio")
	elif get_tree().current_scene.name == "Level 5":
		dialogo.start(dialogue_resource, "fase_5_inicio")
	elif get_tree().current_scene.name == "Level 6":
		dialogo.start(dialogue_resource, "fase_6_inicio")
	
	p_inim = pecas_inimigas.get_children()
	
	init_botoes_peca()

func _process(delta):
	if batalha_acabou == false:
		Global.process_arena()
	
		if Global.game_ended == 1:
			batalha_acabou = true
			disable_tropas()
			show_victory()
		if Global.game_ended == 2:
			batalha_acabou = true
			disable_tropas()
			show_defeat()

func init_banco():
	for i in range(Global.banco.size()):
		var instance = load(Global.banco[i]).instantiate()
		instance.global_position = Vector2(-68, -26 + (16 * i))
		pecas_aliadas.add_child(instance)

func _on_go_to_select_world_pressed():
	Global.music_progress = music_battle.get_playback_position()
	if current_scene.name == "Level 6" and Global.game_ended == 1:
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/pre_game.tscn")

func show_pos_battle_button():
	go_to_select_world.visible = true

func show_victory():
	efeitos.volume_db = -20
	musica.stream = efeito_vitoria
	musica.volume_db = 0
	musica.play()
	victory_warning.visible = true
	var dialogo: Node = BALLOON.instantiate()
	add_child(dialogo)
	if get_tree().current_scene.name == "Level 2":
		dialogo.start(dialogue_resource, "fase_2_final")
	elif get_tree().current_scene.name == "Level 3":
		dialogo.start(dialogue_resource, "fase_3_final")
	elif get_tree().current_scene.name == "Level 4":
		dialogo.start(dialogue_resource, "fase_4_final")
	elif get_tree().current_scene.name == "Level 5":
		dialogo.start(dialogue_resource, "fase_5_final")
	elif get_tree().current_scene.name == "Level 6":
		dialogo.start(dialogue_resource, "fase_6_final")

func show_defeat():
	efeitos.volume_db = -20
	musica.stream = efeito_vitoria
	musica.volume_db = 0
	musica.play()
	if get_tree().current_scene.name == "Level 1":
		var dialogo: Node = BALLOON.instantiate()
		add_child(dialogo)
		dialogo.start(dialogue_resource, "fase_1_final")
	else:
		var dialogo: Node = BALLOON.instantiate()
		add_child(dialogo)
		dialogo.start(dialogue_resource, "derrota")

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
		var ja_tem : bool = false
		var rnum = rng.randi_range(0, p_inim.size() - 1)
		var path = p_inim[rnum].scene_file_path 
		path = ((path).get_slice("_", 0) + "_aliadas/" + (path).get_slice("/", 4)).left(-12) + "Aliado.tscn"
		for i in range(Global.banco.size()):
			if path == Global.banco[i] or path == "res://scenes/peças_aliadas/sabre_Verovia_Aliado.tscn" or path == "res://scenes/peças_aliadas/cajado_Verovia_Aliado.tscn":
				ja_tem = true
		if ja_tem == false and rnum != ja_foi:
			print("entrou: ", path)
			indice_botoes.append(rnum)
			ja_foi = rnum
			if indice_botoes.size() == 2:
				achou = true
	
	if indice_botoes.size() == 2:
		button_peca1.text = (p_inim[indice_botoes[0]].name).get_slice("_", 0) + " de " + p_inim[indice_botoes[0]].name.get_slice("_", 1)
		button_peca1.icon = p_inim[indice_botoes[0]].find_child("Sprite").get_texture()
		button_peca2.text = (p_inim[indice_botoes[1]].name).get_slice("_", 0) + " de " + p_inim[indice_botoes[1]].name.get_slice("_", 1)
		button_peca2.icon = p_inim[indice_botoes[1]].find_child("Sprite").get_texture()
		
		p_paths.append(p_inim[indice_botoes[0]].scene_file_path)
		p_paths.append(p_inim[indice_botoes[1]].scene_file_path)
	elif indice_botoes.size() == 1:
		button_peca1.text = (p_inim[indice_botoes[0]].name).get_slice("_", 0) + " de " + p_inim[indice_botoes[0]].name.get_slice("_", 1)
		button_peca1.icon = p_inim[indice_botoes[0]].find_child("Sprite").get_texture()
		
		p_paths.append(p_inim[indice_botoes[0]].scene_file_path)

func add_peca_banco(indice):
	var path = p_paths[indice]
	path = ((path).get_slice("_", 0) + "_aliadas/" + (path).get_slice("/", 4)).left(-12) + "Aliado.tscn"
	Global.banco.append(path)

func _input(event):
	if Input.is_action_just_pressed("esc"):
		if Global.pause_on == false:
			var instance = pause_menu.instantiate()
			add_child(instance)
			Global.pause_on = true
			get_tree().paused = true
	if Input.is_action_just_pressed("ui_end"):
		var dialogo: Node = BALLOON.instantiate()
		add_child(dialogo)
		dialogo.start(dialogue_resource, "fase_1_final")

func vitoria_pos_dialogo():
	if indice_botoes.size() == 0:
		if current_scene.name == "Level 6":
			go_to_select_world.text = "Voltar ao Menu"
		show_pos_battle_button()
		if current_scene.name != "Level 6":
			next_level_button.visible = true
	elif indice_botoes.size() == 1:
		button_peca2.visible = false
		button_peca1.position = Vector2(-32, -56)
		pickin.visible = true
	else:
		pickin.visible = true

func derrota_pos_dialogo():
	defeat_warning.visible = true
	show_pos_battle_button()
	restart_button.visible = true
	
func disable_tropas():
	pecas_aliadas.set_process_mode(4)
	pecas_inimigas.set_process_mode(4)


func _on_go_to_select_world_2_pressed():
	pass # Replace with function body.
