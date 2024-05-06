extends Node2D

@onready var tile_map = $"../../TileMap"
@onready var sprite = $Sprite

@export var is_player_team := true
@export var velocidade_movimento : float = 0.5
@export var range := 1

var astar_grid: AStarGrid2D
var is_moving: bool
var peças
var peça_alvo

var x := false

func _ready():
	peças = get_tree().get_nodes_in_group("peças")
	
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
		
	move()
	
	
func move():
	var path
	
	var dist_x = abs(global_position.x - peça_alvo.global_position.x);
	var dist_y = abs(global_position.y - peça_alvo.global_position.y);
	if ((dist_x <= range * 16) and global_position.y == peça_alvo.global_position.y) or ((dist_y <= range * 16) and global_position.x == peça_alvo.global_position.x):
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
		sprite.global_position = sprite.global_position.move_toward(global_position, velocidade_movimento)
		
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
