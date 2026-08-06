extends Node

var astar = AStarGrid2D.new()

const TILE_W: int = 64
const TILE_H: int = 32

const DUNGEON_ORIGIN = Vector2(TILE_W/2.0, TILE_H/2.0)

enum TileFlag {
    WALKABLE,
    WALL,
    DOOR,
    OBJECT
}

var location_id: String = ""
var location_name: String = ""

var map_width: int = 0
var map_height: int = 0

var tile_data: Array = []

class TileCell:
    var flag: int = TileFlag.WALKABLE
    var monster_id: int = -1
    var item_id: int = -1
    var object_id: int = -1


func _ready() -> void:
    _init_map()


func _init_map() -> void:
    map_width = 10
    map_height = 10
    tile_data.resize(map_width)
    for x in map_width:
        tile_data[x] = []
        tile_data[x].resize(map_height)
        for y in map_height:
            tile_data[x][y] = TileCell.new()
    
    astar.region = Rect2i(0, 0, map_width, map_height)
    astar.cell_size = Vector2(1, 1)
    astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_AT_LEAST_ONE_WALKABLE
    astar.update()
    
    for x in map_width:
        for y in map_height:
            var cell: TileCell = tile_data[x][y]
            if cell.flag != TileFlag.WALKABLE:
                astar.set_point_solid(Vector2i(x, y), true)

func get_move_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
    if not astar.is_in_boundsv(from) or not astar.is_in_boundsv(to):
        return []
    return astar.get_id_path(from, to)

func is_walkable(tile: Vector2i) -> bool:
    if tile.x < 0 or tile.x >= map_width: return false
    if tile.y < 0 or tile.y >= map_height: return false
    
    var cell: TileCell = tile_data[tile.x][tile.y]
    
    return cell.flag == TileFlag.WALKABLE

func get_monster_at(tile: Vector2i) -> int:
    return tile_data[tile.x][tile.y].monster_id

func get_item_at(tile: Vector2i) -> int:
    return tile_data[tile.x][tile.y].item_id

func get_object_at(tile: Vector2i) -> int:
    return tile_data[tile.x][tile.y].object_id

func world_to_tile(world_pos: Vector2) -> Vector2i:
    var adjusted = world_pos - DUNGEON_ORIGIN
    
    var tile_x: int = int(floor(adjusted.x / TILE_W + adjusted.y / TILE_H))
    var tile_y: int = int(floor(adjusted.y / TILE_H - adjusted.x / TILE_W))
    
    return Vector2i(tile_x, tile_y)

func tile_to_world(tile: Vector2i) -> Vector2:
    return Vector2(
        (tile.x - tile.y) * (TILE_W / 2.0),
        (tile.x + tile.y) * (TILE_H / 2.0)
    ) + DUNGEON_ORIGIN

func is_in_bounds(tile: Vector2i) -> bool:
    return tile.x >= 0 and tile.x < map_width \
       and tile.y >= 0 and tile.y < map_height
