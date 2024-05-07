extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var sprite = $Sprite
@onready var hp_bar = $Sprite/Hp_bar
@onready var timer = $Timer
@onready var glow = $SkillTimerParticles
@onready var skill_timer = $SkillTimer


@export var is_player_team := true
@export var movement_speed : float = 0.5
@export var range := 1
@export var basic_attack_damage := 1
@export var ability_damage := 5
@export var bonus_ability_damage := 15
@export var attack_speed := 0.5
@export var health := 5
@export var mana := 0
@export var mana_max := 25
@export var mouse_over: bool = false
@export var skill_click: bool = false

var bonus_dmg: bool = false
var HIT_BOX = preload("res://scenes/hit_box.tscn")
var astar_grid: AStarGrid2D
var is_attacking: bool
var is_moving: bool
var peças
var peça_alvo
var instance
var timer_speed

var x := false

func _ready():
	peças = get_tree().get_nodes_in_group("peças")
	
	hp_bar.init_health_and_mana(health, mana_max)
	
	timer_speed = 1 / attack_speed
	
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
	if peça_alvo == null:
		atribuir_alvo()
	
	if is_moving:
		return
		
	if is_attacking:
		return
		
	move()
func move():
	var path
	
	var dist_x = abs(global_position.x - peça_alvo.global_position.x);
	var dist_y = abs(global_position.y - peça_alvo.global_position.y);
	if ((dist_x <= range * 16) and global_position.y == peça_alvo.global_position.y) or ((dist_y <= range * 16) and global_position.x == peça_alvo.global_position.x):
		timer.start(timer_speed)
		is_attacking = true
		return
	
	var occupied_posions = []
	
	for peça in peças:
		if peça == self or peça == peça_alvo:
			continue
			
		occupied_posions.append(tile_map.local_to_map(peça.global_position))
	
	
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
	
	for peça in peças:
		if peça == self:
			continue
		
		if peça.is_player_team == !is_player_team:
			var distance = global_position.distance_to(peça.global_position)
			if distance < menor_distancia:
				menor_distancia = distance
				peça_alvo = peça
			elif distance == menor_distancia:
				if is_player_team:
					if peça.global_position.y < peça_alvo.global_position.y:
						peça_alvo = peça
					elif peça.global_position.x < peça_alvo.global_position.x and peça.global_position.y == peça_alvo.global_position.y:
						peça_alvo = peça
				else:
					if peça.global_position.y > peça_alvo.global_position.y:
						peça_alvo = peça
					elif peça.global_position.x > peça_alvo.global_position.x and peça.global_position.y == peça_alvo.global_position.y:
						peça_alvo = peça	
						
	print(peça_alvo)

func basic_attack():
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	instance.set_damage(basic_attack_damage)
	instance.set_is_player_team(is_player_team)
	add_child(instance)
	await get_tree().create_timer(0.1).timeout
	instance.queue_free()
	mana = min(mana_max, mana + 2)
	hp_bar._set_mana(mana)

func _quick_time_event():
	skill_click = true
	glow.emitting = true

func ability():
	#await get_tree().create_timer(0.6).timeout
	mana = 0
	hp_bar._set_mana(mana)
	instance = HIT_BOX.instantiate()
	instance.global_position = peça_alvo.global_position - global_position
	if is_player_team && bonus_dmg:
		instance.set_damage(bonus_ability_damage)
	else:
		instance.set_damage(ability_damage)
	instance.set_is_player_team(is_player_team)
	add_child(instance)
	await get_tree().create_timer(0.1).timeout
	instance.queue_free()
	
func take_damage(damage):
	health -= damage
	hp_bar._set_heath(health)
	mana = min(mana_max, mana + 5)
	hp_bar._set_mana(mana)
		
	if health <= 0:
		queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("attacks") and is_player_team != area.is_player_team:
		take_damage(area.damage)

func _on_timer_timeout():
	if is_player_team:
		print("Timer de ataques acabou")
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
			if event.pressed && skill_click && mouse_over == true:
				bonus_dmg = true
				print("Clicked bonus damage")

func check_mouse_over(viewport, event, shape_idx):
	mouse_over = true

func check_mouse_exited():
	pass # Replace with function body.


func _on_skill_timer_timeout():
	print("Timer Skill timer acabou")
	skill_click = false
	ability()
	if bonus_dmg == true:
		print("Bonus damage!")
		bonus_dmg = false
	skill_timer.stop()
	#ability()
