extends Control

const BALLOON = preload("res://dialogos/balloon.tscn")

@onready var fundo = $Fundo

@export var dialogue_resource : DialogueResource = preload("res://dialogos/cut_scene_Inicial.dialogue")

var fundo1 = preload("res://assets/sprites/Telas_Prancheta 1.png")
var fundo2 = preload("res://assets/sprites/sistema solar GDP PP2024 reparado.png")

var fundos = [fundo1, fundo2]

func _ready():
	if get_tree().current_scene.name == "Cut Scene Inicial": 
		var dialogo: Node = BALLOON.instantiate()
		get_tree().current_scene.add_child(dialogo)
		dialogo.start(dialogue_resource, "tela1")
	
func mudar_fundo(indice):
	fundo.texture = fundos[indice - 1]
	
func fim():
	get_tree().change_scene_to_file("res://scenes/pre_game.tscn")
