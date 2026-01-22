extends Node

var isRailValid: bool
var isPlacingRail = false

var nextUnitIdToAssign = 0
var hasTunnellingSkill = false

@export var unit_scene: PackedScene

signal track_started

@onready var inventory = get_node('HUD/Inventory')

# Called when the node enters the scene tree for the first time.
func _ready():
	get_viewport().physics_object_picking_sort = true
	get_viewport().physics_object_picking_first_only = true
	$ShadowRail.points = PackedVector2Array([Vector2(0,0), Vector2(0,0)])
	DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/narrator.dialogue"), "start_game")
	inventory.dispatch_unit.connect(_on_inventory_dispatch_unit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func pixelsToGrid(pixelPosition):
	return floor(pixelPosition / 64)

func _input(event):
	if Input.is_action_just_pressed("Escape"):
		$ShadowRail.visible = false
		isPlacingRail = false
		Globals.selectedNode = null
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		var mouseGridX = pixelsToGrid(event.position.x)
		var mouseGridY = pixelsToGrid(event.position.y)
		
		var selectedCell = $TileMapLayer.get_cell_tile_data(Vector2(mouseGridX,mouseGridY))
		var selectedTileType
		if (selectedCell):
			selectedTileType = $TileMapLayer.get_cell_tile_data(Vector2(mouseGridX,mouseGridY)).get_custom_data('name')
		
		var lengthOfShadowRail = $ShadowRail.get_point_position(0).distance_to(event.position)

		if isPlacingRail:
			$ShadowRail.set_point_position(1, event.position)

		if event is InputEventMouseButton and event.is_pressed() == true:			
			if event.get_button_index() == 1:
				# If we're placing rail
				if ($Rail.get_point_count() and isRailValid and isPlacingRail):
					$Rail.add_point_override(Vector2(event.position.x, event.position.y))
					
					$ShadowRail.set_point_position(0, event.position)
					Globals.money = Globals.money - int(floor(lengthOfShadowRail))
					await get_tree().create_timer(0.2).timeout
					$LastRailPoint.position = event.position
					if $Rail.get_point_count() == 2:
						track_started.emit()
					# Check if the player has clicked on a EAST coast tile
					if(selectedTileType == 'coast' and event.position.x > get_viewport().get_visible_rect().size.x / 2):
						$ShadowRail.visible = false
						isPlacingRail = false
						DialogueManager.show_dialogue_balloon(load("res://scenes/dialogue/narrator.dialogue"), "end_game")
						$MoneyTimer.stop()
				
				# If we're placing the first station check if the player has clicked on a WEST coast tile
				elif(!$Rail.get_point_count() and selectedTileType == 'coast' and event.position.x < get_viewport().get_visible_rect().size.x / 2):				
					$Rail.add_point(Vector2(event.position.x, event.position.y))
					$ShadowRail.set_point_position(0, event.position)
					
					await get_tree().create_timer(0.2).timeout
					$Station.visible = true
					$Station.position = event.position
					
func _on_timer_timeout() -> void:
	Globals.money = Globals.money + 1

func _on_last_rail_point_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		$ShadowRail.set_point_position(1, event.position)
		$ShadowRail.visible = true
		isPlacingRail = true
		Globals.selectedNode = $Rail

func _on_station_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		Globals.selectedNode = $Station

func _on_inventory_dispatch_unit(transferInventory: Dictionary) -> void:
	var unit = unit_scene.instantiate()
	unit.id = nextUnitIdToAssign
	unit.inventory = transferInventory
	nextUnitIdToAssign = nextUnitIdToAssign + 1
	unit.position = $Rail.get_point_position(0) + Vector2(0, 20)
	add_child(unit)

func _on_hud_place_first_track() -> void:
	isPlacingRail = true
	$ShadowRail.set_point_position(0, $Station.position)
	$ShadowRail.set_point_position(1, $Station.position)
	$ShadowRail.visible = true
	Globals.selectedNode = $Rail

func _on_hud_buy_tunnelling() -> void:
	if (Globals.money > 100):
		Globals.money = Globals.money - 100
		hasTunnellingSkill = true
		$HUD/StationOptions/Tunnelling.visible = false
		
