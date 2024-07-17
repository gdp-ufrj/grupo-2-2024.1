extends Node2D

const BALLOON = preload("res://dialogos/balloon.tscn")

@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "start"

func _ready():
	var dialogo: Node = BALLOON.instantiate()
	get_tree().current_scene.add_child(dialogo)
	dialogo.start(dialogue_resource, dialogue_start)
