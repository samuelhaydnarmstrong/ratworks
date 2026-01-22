extends Camera2D

var tilemap: TileMapLayer

func _ready():
	await get_tree().process_frame
	var tilemaps = get_tree().get_nodes_in_group("MainMap")
	for map in tilemaps:
		if map.name == "TileMapLayer":
			tilemap = map
	
	var used_rect: Rect2i = tilemap.get_used_rect()
	var tile_map_size = tilemap.tile_set.get_tile_size()
	
	limit_left = used_rect.position.x
	limit_top = used_rect.position.y * tile_map_size.y
	limit_right = (used_rect.position.x + used_rect.size.x) * tile_map_size.x
	limit_bottom = (used_rect.position.y + used_rect.size.y) * tile_map_size.y

var isHoldingLeftClick = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP && self.zoom < Vector2(2, 2):
			self.zoom += Vector2(0.1, 0.1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN && self.zoom > Vector2(1, 1):
			self.zoom -= Vector2(0.1, 0.1)
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed():
			isHoldingLeftClick = true
		if event.button_index == MOUSE_BUTTON_LEFT && event.is_released():
			isHoldingLeftClick = false
	if event is InputEventMouseMotion && isHoldingLeftClick:
		global_position -= event.relative
