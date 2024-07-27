extends Control

const BALLOON = preload("res://dialogos/balloon.tscn")

@onready var fundo = $Fundo

@export var dialogue_resource : DialogueResource = preload("res://dialogos/cut_scene_Inicial.dialogue")

var fundo0 = preload("res://assets/sprites/Telas_Prancheta 1.png")
var fundo1 = preload("res://assets/sprites/Inicio_Prancheta 1 cópia 3 (1).png")
var fundo2 = preload("res://assets/sprites/Inicio_Prancheta 1.png")
var fundo3 = preload("res://assets/sprites/Inicio-02.png")
var fundo4 = preload("res://assets/sprites/Telas_Prancheta 1.png")
var fundo5 = preload("res://assets/sprites/Inicio_Prancheta 1 cópia 2.png")
var fundo6 = preload("res://assets/sprites/Inicio-07.png")
var fundo7 = preload("res://assets/sprites/Inicio-03.png")
var fundo8 = preload("res://assets/sprites/Telas_Prancheta 1.png")
var fundo9 = preload("res://assets/sprites/tela_preta.png")

var fundos = [fundo0, fundo1, fundo2, fundo3, fundo4, fundo5, fundo6, fundo7, fundo8, fundo9]

func _ready():
	if get_tree().current_scene.name == "Cut Scene Inicial": 
		var dialogo: Node = BALLOON.instantiate()
		get_tree().current_scene.add_child(dialogo)
		dialogo.start(dialogue_resource, "tela1")
	
func mudar_fundo(indice):
	fundo.texture = fundos[indice - 1]
	
func fim():
	get_tree().change_scene_to_file("res://scenes/pre_game.tscn")
