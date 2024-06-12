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

var is_player_team : bool
var movement_speed : float = 0.5
var range := 1
var basic_attack_damage := 1
var ability_damage := 5
var bonus := 10
var attack_speed := 0.5
var health := 5
var mana := 0
var mana_max := 25
var mana_por_hit := 10
var mouse_over: bool = false
var skill_click: bool = false
var try_skill_click:bool = false

###############Drag and drop###############
var another_piece_present := false
var being_dragged:= false
var occupying := false
var draggable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initialPos: Vector2
var current_plataform
var old_plataform
############^^^Drag and drop^^^############

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
var direçao

func _ready():
	
	peças = get_tree().get_nodes_in_group("peças")
	
	print(self.name, " ", is_player_team)
	
	timer_speed = 1 / attack_speed
	
	hp_bar.init_health_and_mana(health, mana_max, mana, is_player_team)
	
	if is_player_team:
		direçao = Vector2(0, -16)
	else:
		direçao = Vector2(0, 16)
	
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position
	
	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(
				x + region_position.x,
				y + region_position.y
			)
			
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if tile_data == null or not tile_data.get_custom_data("andavel"):
				astar_grid.set_point_solid(tile_position)


func _process(delta):
	if Global.combat_started == false:
		if is_player_team:
			check_drag()
	else:
		if peça_alvo == null:
			is_attacking = false
			timer.stop()
			atribuir_alvo()
		
		if is_moving:
			return
			
		if is_attacking:
			return
			
		move()


func move():
	peças = get_tree().get_nodes_in_group("peças")
	
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
	
	direçao = global_position - original_position
	
	is_moving = true


func _physics_process(delta):
	if is_moving:
		sprite.global_position = sprite.global_position.move_toward(global_position, movement_speed)
		
		if sprite.global_position != global_position:
			return
		
		is_moving = false


func atribuir_alvo():
	var menor_distancia = 100000
	
	peças = get_tree().get_nodes_in_group("peças")
	
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


func basic_attack():
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	instance.set_damage(basic_attack_damage)
	instance.set_is_player_team(is_player_team)
	instance.set_timer(0.1)
	add_child(instance)
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
	if area.is_in_group("attacks") and is_player_team != area.is_player_team and area.is_burn == false:
		take_damage(area.damage)
	elif area.is_in_group("attacks") and is_player_team != area.is_player_team and area.is_burn == true:
		queimar(area.damage, 3)

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
					if mouse_over == true && Global.combat_started:
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


func _on_timer_after_skill_timeout():
	if try_skill_click == true:
		try_skill_click = false
		print(piece.name, ": Perdão aplicado")


func habilidade():
	pass


func queimar(dano, tempo):
	var _dano : float = dano/5.0
	var _tempo : float = tempo/5.0
	for x in 5:
		take_damage(_dano)
		await get_tree().create_timer(_tempo).timeout


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


func _on_area_2d_mouse_exited():
	mouse_over = false


func check_drag():
	if draggable:
		if Input.is_action_just_pressed("click"):
			initialPos = global_position
			offset = get_global_mouse_position() - global_position
			Global.is_dragging = true
			being_dragged = true
		if Input.is_action_pressed("click") && being_dragged:
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			Global.is_dragging = false
			being_dragged = false
			if is_inside_dropable:
				if body_ref.is_in_group("free") && another_piece_present== false:
					body_ref.add_to_group("occupied")
					body_ref.remove_from_group("free")
					if old_plataform== null:
						pass
					else:
						old_plataform.add_to_group("free")
						old_plataform.remove_from_group("occupied")
					go_to_new_plataform()
				else:
					#if body_ref.is_in_group("bench"):
						#if body_ref.is_in_group("occupied") && body_ref.first_time:
							#if old_plataform==null:
								#pass
							#elif old_plataform.is_in_group("bench"):
								#back_to_old_plataform()
						#else:
							##go_to_new_plataform()
					#else:
					back_to_old_plataform()
					print("Ocupado amigo!")
			else:
				print("Posição inválida")
				back_to_old_plataform()


func _on_drag_drop_area_2d_body_entered(body:StaticBody2D):
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body.modulate = Color(Color.REBECCA_PURPLE,1)
		body_ref = body


func _on_drag_drop_area_2d_body_exited(body:StaticBody2D):
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)


func _on_drag_drop_area_2d_mouse_entered():
	if not Global.is_dragging && is_player_team && Global.combat_started == false:
		draggable = true
		scale = Vector2(1.05,1.05)


func _on_drag_drop_area_2d_mouse_exited():
	if not Global.is_dragging && is_player_team && Global.combat_started == false:
		draggable = false
		scale = Vector2(1,1)

func check_current():
	print(body_ref,"está no grupo free:",body_ref.is_in_group("free"))
	print(body_ref,"está no grupo occupied:",body_ref.is_in_group("occupied"))

func check_old_plataform():
	print("old plataform:",old_plataform,"está no grupo free:",old_plataform.is_in_group("free"))
	print("old plataform:",old_plataform,"está no grupo occupied:",old_plataform.is_in_group("occupied"))
	#if old_plataform == null:
		#old plataform =

func back_to_old_plataform():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"global_position", initialPos,0.1).set_ease(Tween.EASE_OUT)

func go_to_new_plataform():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position", body_ref.position,0.1).set_ease(Tween.EASE_OUT)
	old_plataform = body_ref



