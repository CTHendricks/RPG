extends Node

var floor: TileMapLayer
var walls
var objects

const SOURCE_ID = 0
const FLOOR_ATLAS = Vector2i(0, 0)

func setup(new_floor: TileMapLayer):
	floor = new_floor

func render_tiles(rows: Array) -> void:
	floor.clear()
	
	for y in range(rows.size()):
		var row: String = rows[y]
		
		for x in range(row.length()):
			var tile = Vector2i(x, y)
			print(tile)
			var ch = row[x]
			
			match ch:
				".":
					floor.set_cell(tile, SOURCE_ID, FLOOR_ATLAS)
