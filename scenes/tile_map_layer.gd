extends TileMapLayer

@export var main: Node
@export var fogOfWar: TileMapLayer

var prevSelectedCell: Vector2i

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.pressed and event.button_index == MOUSE_BUTTON_LEFT && !main.isPlacingRail:
		var selectedCell = Vector2i(
			main.pixelsToGrid(event.position.x),
			main.pixelsToGrid(event.position.y)
		)
		
		if (prevSelectedCell != selectedCell):
			prevSelectedCell = selectedCell
			
			var fog_data = fogOfWar.get_cell_tile_data(selectedCell)
			var tile_data = self.get_cell_tile_data(selectedCell)
			
			if fog_data == null or tile_data == null:
				return
				
			var isFog = fog_data.get_custom_data("isFog")
			var selectedTileType = tile_data.get_custom_data("name")

			main.local_update_selected_feature({"name": 'fog' if isFog else selectedTileType, "id": -1})
