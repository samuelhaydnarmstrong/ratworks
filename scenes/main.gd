extends Node

var shadowRail = PackedVector2Array([Vector2(0,0), Vector2(0,0)])
var isRailValid

var MAX_RAIL_LENGTH = 100

# get_viewport().get_visible_rect().size.x
#var x = floor(event.position.x / 64)
#var y = floor(event.position.y / 64)
#$TileMapLayer.set_cell(Vector2i(x, y), 1, Vector2i(2,2),1)	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event):
	if($ShadowRail.visible):
		shadowRail.set(1,event.position)
		$ShadowRail.points = shadowRail
		if (shadowRail.get(0).distance_to(event.position) > MAX_RAIL_LENGTH):
			$ShadowRail.set_default_color(Color(1, 0, 0, 1))
			isRailValid = false
		else:
			$ShadowRail.set_default_color(Color(0, 1, 0, 1))
			isRailValid = true
		
	if event is InputEventMouseButton and event.is_pressed() == true:
		if event.get_button_index() == 1:
			var x = floor(event.position.x / 64)
			var y = floor(event.position.y / 64)
			
			if ($Rail.get_point_count() and isRailValid and $ShadowRail.visible): # If we're placing rail
				
				$Rail.add_point(Vector2(event.position.x, event.position.y))
				shadowRail.set(0, event.position)
				shadowRail.set(0, event.position)
				
				# Check if the player has clicked on a EAST coast tile
				if($TileMapLayer.get_cell_atlas_coords(Vector2i(x, y)) == Vector2i(0,1) and event.position.x > get_viewport().get_visible_rect().size.x / 2):
					$Label.text = "You win!"
					$ShadowRail.visible = false
			elif(!$Rail.get_point_count()): # If we're placing the first station
				# Check if the player has clicked on a WEST coast tile
				if($TileMapLayer.get_cell_atlas_coords(Vector2i(x, y)) == Vector2i(0,1) and event.position.x < get_viewport().get_visible_rect().size.x / 2):
					$Rail.add_point(Vector2(event.position.x, event.position.y))
					shadowRail.set(0, event.position)
					$ShadowRail.visible = true
		elif event.get_button_index() == 2:
			$ShadowRail.visible = false
