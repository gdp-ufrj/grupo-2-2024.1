extends Node2D

const BALLOON = preload("res://dialogos/balloon.tscn")

@export var dialogue_resource : DialogueResource = preload("res://dialogos/inicio_fase.dialogue")

var dialogo_iniciado : bool = false

func _ready():
	var dialogo: Node = BALLOON.instantiate()
	get_tree().current_scene.add_child(dialogo)
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
