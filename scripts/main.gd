extends Node

@onready var floor: TileMapLayer = $floor

@onready var player: CharacterBody2D = $player

@onready var grid_tile_map: Node = $grid_tile_map
@onready var map_manager: Node = $map_manager

func _ready() -> void:
	player.setup(grid_tile_map)
	player.position = Vector2(32.0, 16.0)
	map_manager.setup(floor)
	map_manager.render_tiles(["..........",
	"..........",
	"..........",
	"..........",
	"..........",
	"..........",
	"..........",
	"..........",
	"..........",
	".........."])

func _process(delta: float) -> void:
	pass
