extends Node2D

class_name peça
#DEUS É BOM E O DIABO NÃO PRESTA
@onready var tile_map = $"../../TileMap"
@onready var sprite = $Sprite
@onready var hp_bar = $Sprite/Hp_bar
@onready var timer = $Timer
@onready var glow = $SkillTimerParticles
@onready var skill_timer = $SkillTimer
@onready var timer_after_skill = $TimerAfterSkill
@onready var piece = $"."

@export var is_player_team := true
@export var movement_speed : float = 0.5
@export var range := 1
@export var basic_attack_damage := 1
@export var ability_damage := 5
@export var bonus := 10
@export var bonus_ability_damage := 35
@export var attack_speed := 0.5
@export var health := 5
@export var mana := 0
@export var mana_max := 25
@export var mana_por_hit := 10
@export var mouse_over: bool = false
@export var skill_click: bool = false
@export var try_skill_click:bool = false

var bonus_dmg: bool = false
var HIT_BOX = preload("res://scenes/hit_box.tscn")
var astar_grid: AStarGrid2D
var is_attacking: bool
var is_moving: bool
var usando_habilidade: bool = false
var peças
var peça_alvo
var instance
var timer_speed
var occupied_posions

func move():
	var path
	
	occupied_posions = []
	
	var dist_x = abs(global_position.x - peça_alvo.global_position.x);
	var dist_y = abs(global_position.y - peça_alvo.global_position.y);
	
	for p in peças:
		if p == self or p == peça_alvo:
			continue
			
		occupied_posions.append(tile_map.local_to_map(p.global_position))
	
	
	for occupied_posion in occupied_posions:
		astar_grid.set_point_solid(occupied_posion)
	
	if range == 1:
		path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(peça_alvo.global_position)
		)
	else:
		if dist_x < dist_y and dist_x != 0:
			var pos = Vector2i (peça_alvo.global_position.x, global_position.y)
			path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(pos)
			)
		elif dist_y < dist_x and dist_y != 0:
			var pos = Vector2i (global_position.x, peça_alvo.global_position.y)
			path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(pos)
			)
		else:
			path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(peça_alvo.global_position)
		)
	
	for occupied_posion in occupied_posions:
		astar_grid.set_point_solid(occupied_posion, false)
	
	path.pop_front()
	
	if ((dist_x <= range * 16) and global_position.y == peça_alvo.global_position.y) or ((dist_y <= range * 16) and global_position.x == peça_alvo.global_position.x):
		timer.start(timer_speed)
		is_attacking = true
		return
	
	if path.is_empty():
		print("nao achou")
		return
	
	var original_position = Vector2(global_position)
	
	global_position = tile_map.map_to_local(path[0])
	sprite.global_position = original_position
	
	is_moving = true

func _physics_process(delta):
	if is_moving:
		sprite.global_position = sprite.global_position.move_toward(global_position, movement_speed)
		
		if sprite.global_position != global_position:
			return
		
		is_moving = false

func atribuir_alvo():
	var menor_distancia = 100000
	
	for p in peças:
		if p == self:
			continue
		
		if p.is_player_team == !is_player_team:
			var distance = global_position.distance_to(p.global_position)
			if distance < menor_distancia:
				menor_distancia = distance
				peça_alvo = p
			elif distance == menor_distancia:
				if is_player_team:
					if p.global_position.y < peça_alvo.global_position.y:
						peça_alvo = p
					elif p.global_position.x < peça_alvo.global_position.x and p.global_position.y == peça_alvo.global_position.y:
						peça_alvo = p
				else:
					if p.global_position.y > peça_alvo.global_position.y:
						peça_alvo = p
					elif p.global_position.x > peça_alvo.global_position.x and p.global_position.y == peça_alvo.global_position.y:
						peça_alvo = p	
						
	print(peça_alvo)

func basic_attack():
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	instance.set_damage(basic_attack_damage)
	instance.set_is_player_team(is_player_team)
	add_child(instance)
	await get_tree().create_timer(0.1).timeout
	instance.queue_free()
	mana = min(mana_max, mana + mana_por_hit)
	hp_bar._set_mana(mana)

func _quick_time_event():
	skill_click = true
	glow.emitting = true

func ability():
	mana = 0
	hp_bar._set_mana(mana)
	habilidade()
	timer_after_skill.start()
	
func take_damage(damage):
	health -= damage
	hp_bar._set_heath(health)
		
	if health <= 0:
		queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("attacks") and is_player_team != area.is_player_team:
		take_damage(area.damage)

func _on_timer_timeout():
	if mana == mana_max:
		if is_player_team:
			skill_timer.start()
			_quick_time_event()
		else:
			ability()
	else:
		basic_attack()

#Check click
func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if is_player_team:
				if event.pressed:
					if mouse_over == true: 
						if skill_click && try_skill_click == false:
							bonus_dmg = true
							print(piece.name, " Bonus damage!!!!!!!!!") 
						else:
							print(piece.name, " Errou o click")
							try_skill_click = true

func check_mouse_over(viewport, event, shape_idx):
	mouse_over = true

func _on_skill_timer_timeout():
	skill_click = false
	ability()
	if bonus_dmg == true:
		bonus_dmg = false
	skill_timer.stop()
	try_skill_click = false

func _on_area_2d_mouse_exited():
	mouse_over = false


func _on_timer_after_skill_timeout():
	if try_skill_click == true:
		try_skill_click = false
		print(piece.name, ": Perdão aplicado")
		
func habilidade():
	pass

func enemy_bonus_dmg_randomizer():
	var randnumb = randi() % 100+1
	if randnumb > 5:
		return true
	else:
		return false

func skill_effect():
	instance.set_damage(ability_damage)

func bonus_skill_effect():
	instance.set_damage(ability_damage + bonus)
