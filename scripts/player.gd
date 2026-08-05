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

var current_cursor_action: Action = Action.NONE
var current_cursor_x: int = -1
var current_cursor_y: int = -1

var path_array: Array[Vector2i] = []
var path_index: int = 0


func _physics_process(delta: float) -> void:
	_tick_walk()


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
	var from_tile = get_current_tile()
	path_array = grid_tile_map.get_move_path(from_tile, target_tile)
	path_index = 0


func _tick_walk() -> void:
	if path_index >= path_array.size():
		return
	
	var next_tile = path_array[path_index]
	path_index += 1
	position = grid_tile_map.tile_to_world(next_tile)


func get_current_tile() -> Vector2i:
	return grid_tile_map.world_to_tile(global_position)
