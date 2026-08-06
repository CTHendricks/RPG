extends CharacterBody2D

@onready var p_navigation: NavigationAgent2D = $p_navigation

var grid_tile_map

enum Action {
	NONE,
	WALK,
	ATTACK,
	PICKUP,
	INTERACT
}

var move_speed = 120

var current_cursor_action: Action = Action.NONE
var current_cursor_x: int = -1
var current_cursor_y: int = -1

var path_array: Array[Vector2i] = []
var path_index: int = 0

var current_tile = Vector2i.ZERO
var next_tile = Vector2i.ZERO

var target_position: Vector2
var is_walking: bool = false


func _physics_process(delta: float) -> void:
	_tick_walk(delta)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_on_left_click(get_global_mouse_position())
			var mp = get_global_mouse_position()
			var tile = grid_tile_map.world_to_tile(mp)
			var in_bounds: bool = grid_tile_map.is_in_bounds(tile)
			print("mouse world=", mp, " -> tile=", tile, " in_bounds=", in_bounds)


func setup(new_grid_tile_map):
	grid_tile_map = new_grid_tile_map


func _on_left_click(world_pos: Vector2) -> void:
	var tile: Vector2i = grid_tile_map.world_to_tile(world_pos)
	
	"""
	var monster_id: int = GridTileMap.get_monster_at(world_pos)
	var item_id: int = GridTileMap.get_item_at(world_pos)
	var object_id: int = GridTileMap.get_object_at(world_pos)
	
	if monster_id != -1:
		current_cursor_action = Action.ATTACK
		current_cursor_x = tile.x
		current_cursor_y = tile.y
	elif item_id != -1:
		current_cursor_action = Action.PICKUP
		current_cursor_x = tile.x
		current_cursor_y = tile.y
	elif object_id != 1:
		current_cursor_action = Action.INTERACT
		current_cursor_x = tile.x
		current_cursor_y = tile.y
	else:
		"""
	current_cursor_action = Action.WALK
	current_cursor_x = tile.x
	current_cursor_y = tile.y
	
	_run_pathfind(tile)


func _run_pathfind(target_tile: Vector2i) -> void:
	var from_tile = next_tile
	print(current_tile, next_tile, target_position)
	path_array = grid_tile_map.get_move_path(from_tile, target_tile)
	print(path_array)
	path_index = 0
	
	if path_array.size() > 0 and path_array[0] == from_tile:
		path_index = 1
	
	if not is_walking:
		_advance_to_next_tile()


func _tick_walk(delta: float) -> void:
	if not is_walking:
		return
	
	var remaining_distance = move_speed * delta
	
	while remaining_distance > 0.0 and is_walking:
		var distance_to_target = global_position.distance_to(target_position)
		
		if remaining_distance >= distance_to_target:
			global_position = target_position
			current_tile = next_tile
			remaining_distance -= distance_to_target
			_advance_to_next_tile()
		else:
			global_position = global_position.move_toward(target_position, remaining_distance)
			remaining_distance = 0.0

func _advance_to_next_tile():
	if path_index >= path_array.size():
		is_walking = false
		target_position = current_tile
		return
	
	next_tile = path_array[path_index]
	path_index += 1
	
	target_position = grid_tile_map.tile_to_world(next_tile)
	is_walking = true


func get_current_tile() -> Vector2i:
	return current_tile
