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
@onready var glow_before_qte = $GlowBeforeQTE
@onready var glow_after_qte_sucess = $GlowAfterQTESucess
@onready var timer_before_qte = $TimerBeforeQTE
@onready var glow_after_qte_failure = $GlowAfterQTEFailure
@onready var efeitos = $Efeitos
@export var glow_before_timer_started:= false
@export var emitting_before:= false
var broquel_first_skill:= true


var is_player_team : bool
var movement_speed : float = 0.5
var nome : String
var imagem
var bonus_tipo : String
var habilidade_txt : String
var range : int
var basic_attack_damage : int
var ability_damage : int
var bonus : int
var attack_speed : float = 0.5
var health : int
var mana : int
var mana_max : int
var mana_por_hit : int
var classe : String
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

var desbugar: bool = false
var bonus_dmg: bool = false
var HIT_BOX = preload("res://scenes/hit_box.tscn")
var efeito_hit = preload("res://assets/musicas/hitbasico2_sfx.mp3")
var efeito_hab = preload("res://assets/musicas/hitmagia2_sfx.mp3")
var efeito_drop = preload("res://assets/musicas/dropar2_sfx.mp3")
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
var original_position

func _ready():
	
	peças = get_tree().get_nodes_in_group("peças")
	
	timer_speed = 1 / attack_speed
	
	if is_player_team:
		direçao = Vector2(0, -16)
		if get_tree().current_scene.name == "Level 6":
			health += 10 * Global.num_broquel_ali
			basic_attack_damage += 2 * Global.num_flecha_ali
			ability_damage += 4 * Global.num_cajado_ali
			bonus += 3 * Global.num_sabre_ali
		elif get_tree().current_scene.name == "Level 5":
			health += 10 * max(Global.num_broquel_ali - 1, 0)
			basic_attack_damage += 2 * max(Global.num_flecha_ali - 1, 0)
			ability_damage += 4 * max(Global.num_cajado_ali - 1, 0)
			bonus += 3 * max(Global.num_sabre_ali - 1, 0)
	
	hp_bar.init_health_and_mana(health, mana_max, mana, is_player_team)
	
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
		if is_player_team:
			if glow_before_timer_started == false:
					if mana >= mana_max/2:
						timer_before_qte.start()
						glow_before_timer_started = true
						if piece.name == "Broquel_Turonia_Aliado":
							if broquel_first_skill:
								broquel_first_skill = false
								timer_before_qte.set_wait_time(4.5)
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
		if dist_x < dist_y and dist_x != 0 and desbugar == false:
			var pos = Vector2i (peça_alvo.global_position.x, global_position.y)
			path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(pos)
			)
		elif dist_y < dist_x and dist_y != 0  and desbugar == false:
			var pos = Vector2i (global_position.x, peça_alvo.global_position.y)
			path = astar_grid.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(pos)
			)
		else:
			desbugar = true
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
		desbugar = false
		return
	
	if (global_position.x > 56 or global_position.x < -40 or global_position.y > 40 or global_position.y < -40):
		global_position = original_position
	
	if path.is_empty():
		print(self.name, ": nao achou")
		return
	
	original_position = Vector2(global_position)
	
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
	var dist_x = abs(global_position.x - peça_alvo.global_position.x);
	var dist_y = abs(global_position.y - peça_alvo.global_position.y);
	
	if (dist_x != 0 and dist_y != 0) or (dist_x == 0 and dist_y > range * 16) or (dist_x > range * 16 and dist_y == 0):
		is_attacking = false
		timer.stop()
		atribuir_alvo()
		return
	
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	instance.set_damage(basic_attack_damage)
	instance.set_is_player_team(is_player_team)
	instance.set_timer(0.1)
	efeitos.stream = efeito_hit
	efeitos.play()
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


func take_damage(_damage):
	health -= _damage
	hp_bar._set_heath(health)
	print(self.name, ": vida -> ", health, " / dano -> ", _damage)
	sprite.set_self_modulate(Color(255,0,0,255))
	if health <= 0:
		queue_free()
	else:
		await get_tree().create_timer(0.1).timeout
		sprite.set_self_modulate(Color(1,1,1,1)) 


func _on_area_2d_area_entered(area):
	if area.is_in_group("attacks") and is_player_team != area.is_player_team and area.is_burn == false:
		take_damage(area.damage)
	elif area.is_in_group("attacks") and is_player_team != area.is_player_team and area.is_burn == true:
		queimar(area.damage, 3)

func _on_timer_timeout():
	if mana == mana_max:
		if is_player_team:
			skill_timer.start()
			glow_before_qte.emitting = false
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
	glow.emitting = false
	ability()
	#emitting_before = false
	if bonus_dmg == true:
		show_sucess_qte()
		bonus_dmg = false
	skill_timer.stop()
	if try_skill_click:
		try_skill_click = false
		show_failure_qte()


func _on_timer_after_skill_timeout():
	if try_skill_click == true:
		try_skill_click = false
		print(piece.name, ": Perdão aplicado")
		show_failure_qte()
	glow_before_timer_started = false


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
	print(self.name, ": ", randnumb)
	if randnumb > 66:
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
					efeitos.stream = efeito_drop
					efeitos.play()
				else:
					back_to_old_plataform()
					print("Ocupado amigo!")
					efeitos.stream = efeito_drop
					efeitos.play()
			else:
				print("Posição inválida")
				back_to_old_plataform()
				efeitos.stream = efeito_drop
				efeitos.play()


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

func show_sucess_qte():
	glow_after_qte_sucess.emitting = true

func show_failure_qte():
	glow_after_qte_failure.emitting = true
	
func _on_timer_before_qte_timeout():
	glow_before_qte.emitting = true
