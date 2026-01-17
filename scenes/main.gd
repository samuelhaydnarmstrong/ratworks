extends Node

var isRailValid: bool
var isPlacingRail = false

var FOG_OF_WAR = Vector2i(1,1)
var GRASS = Vector2i(1,0)
var COAST = Vector2i(0,1)
var WATER = Vector2i(0,0)

var money = 0

@export var surveyor_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
	$ShadowRail.points = PackedVector2Array([Vector2(0,0), Vector2(0,0)])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _input(event):
	var mouseGridX = floor(event.position.x / 64)
	var mouseGridY = floor(event.position.y / 64)
	var selectedTileType = $TileMapLayer.get_cell_atlas_coords(Vector2i(mouseGridX,mouseGridY))
	var isFogOfWarTile = $FogOfWar.get_cell_atlas_coords(Vector2i(mouseGridX,mouseGridY)) == Vector2i(0,1)
	var lengthOfShadowRail = $ShadowRail.get_point_position(0).distance_to(event.position)
	
	if(isPlacingRail):
		$ShadowRail.set_point_position(1, event.position)
		if (lengthOfShadowRail > money or isFogOfWarTile or selectedTileType == WATER):
			$ShadowRail.set_default_color(Color(1, 0, 0, 1))
			isRailValid = false
		else:
			$ShadowRail.set_default_color(Color(0, 1, 0, 1))
			isRailValid = true
		
	if event is InputEventMouseButton and event.is_pressed() == true:
		if event.get_button_index() == 1:
			# If we're placing rail
			if ($Rail.get_point_count() and isRailValid and isPlacingRail):
				# If we're placing it on grass
				if (selectedTileType == GRASS or selectedTileType == COAST): 
					$Rail.add_point(Vector2(event.position.x, event.position.y))
					$ShadowRail.set_point_position(0, event.position)
					update_money(money - int(floor(lengthOfShadowRail)))
					await get_tree().create_timer(0.2).timeout
					$LastRailPoint.position = event.position
				# Check if the player has clicked on a EAST coast tile
				if(selectedTileType == COAST and event.position.x > get_viewport().get_visible_rect().size.x / 2):
					$Label.text = "You win!"
					$ShadowRail.visible = false
					isPlacingRail = false
			
			# If we're placing the first station check if the player has clicked on a WEST coast tile
			elif(!$Rail.get_point_count() and selectedTileType == COAST and event.position.x < get_viewport().get_visible_rect().size.x / 2):
				$Label.text = ""
				
				$Rail.add_point(Vector2(event.position.x, event.position.y))
				$ShadowRail.set_point_position(0, event.position)
				
				await get_tree().create_timer(0.2).timeout
				$Station.visible = true
				$Station.position = event.position
				
				$LastRailPoint.position = event.position
		elif event.get_button_index() == 2 and isPlacingRail:
			$ShadowRail.visible = false
			isPlacingRail = false
			$BuildSurveyorButton.visible = false
			$Label.text = ""
			$SelectedUnitLabel.text = ''

func _on_timer_timeout() -> void:
	update_money(money+1)

func update_money(newMoney):
	money = int(newMoney)
	$MoneyValue.text = str(newMoney)

func _on_build_surveyor_button_pressed() -> void:
	var surveyor = surveyor_scene.instantiate()
	surveyor.position = $Rail.get_point_position(0)
	add_child(surveyor)

func _on_last_rail_point_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		$ShadowRail.set_point_position(1, event.position)
		$ShadowRail.visible = true
		isPlacingRail = true
		$SelectedUnitLabel.text = 'Front of the Track'

func _on_station_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		$SelectedUnitLabel.text = 'Station'
		$BuildSurveyorButton.visible = true
