extends Node

var shadowRail = PackedVector2Array([Vector2(0,0), Vector2(0,0)])
var isRailValid
var selectedController = "" 
var desiredSurveyorPosition

var MAX_RAIL_LENGTH = 100

var FOG_OF_WAR = Vector2i(1,1)
var GRASS = Vector2i(1,0)
var COAST = Vector2i(0,1)
var WATER = Vector2i(0,0)

# get_viewport().get_visible_rect().size.x
#var x = floor(event.position.x / 64)
#var y = floor(event.position.y / 64)
#$TileMapLayer.set_cell(Vector2i(x, y), 1, Vector2i(2,2),1)	

# Called when the node enters the scene tree for the first time.
func _ready():
	desiredSurveyorPosition = $Surveyor.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if ($Surveyor.position != desiredSurveyorPosition):
		$Surveyor.position = $Surveyor.position.move_toward(desiredSurveyorPosition,0.4)
	var surveyorX = floor($Surveyor.position.x / 64)
	var surveyorY = floor($Surveyor.position.y / 64)
	if ($TileMapLayer.get_cell_atlas_coords(Vector2i(surveyorX, surveyorY)) == FOG_OF_WAR):
		$TileMapLayer.set_cell(Vector2i(surveyorX, surveyorY),0,GRASS)

func _input(event):
	var mouseGridX = floor(event.position.x / 64)
	var mouseGridY = floor(event.position.y / 64)
	var selectedTileType = $TileMapLayer.get_cell_atlas_coords(Vector2i(mouseGridX,mouseGridY))
	
	if($ShadowRail.visible):
		shadowRail.set(1,event.position)
		$ShadowRail.points = shadowRail

		
		if (shadowRail.get(0).distance_to(event.position) > MAX_RAIL_LENGTH or selectedTileType == FOG_OF_WAR):
			$ShadowRail.set_default_color(Color(1, 0, 0, 1))
			isRailValid = false
		else:
			$ShadowRail.set_default_color(Color(0, 1, 0, 1))
			isRailValid = true
		
	if event is InputEventMouseButton and event.is_pressed() == true:
		if event.get_button_index() == 1:
			if (event.position.distance_to($Rail.get_point_position($Rail.get_point_count()-1)) < 10):
				shadowRail.set(1,event.position)
				$ShadowRail.points = shadowRail
				$ShadowRail.visible = true
				selectedController = "Rail"
				$Label.text = "Rail selected"
				return
			
			if (selectedController == "Surveyor" && selectedTileType != WATER):
				desiredSurveyorPosition = event.position
			else:
				if ($Rail.get_point_count() and isRailValid and selectedController == "Rail"): # If we're placing rail
					if (selectedTileType == GRASS or selectedTileType == COAST): # If we're placing it on grass
						$Rail.add_point(Vector2(event.position.x, event.position.y))	
						shadowRail.set(0, event.position)				
					# Check if the player has clicked on a EAST coast tile
					if(selectedTileType == COAST and event.position.x > get_viewport().get_visible_rect().size.x / 2):
						$Rail.add_point(Vector2(event.position.x, event.position.y))
						$Label.text = "You win!"
						$ShadowRail.visible = false
						shadowRail.set(0, event.position)
				elif(!$Rail.get_point_count() and selectedTileType == COAST and event.position.x < get_viewport().get_visible_rect().size.x / 2): # If we're placing the first station
					# Check if the player has clicked on a WEST coast tile
					$Label.text = "Rail selected"
					$Rail.add_point(Vector2(event.position.x, event.position.y))
					shadowRail.set(0, event.position)
					$ShadowRail.visible = true
					selectedController = "Rail"
					$Surveyor.modulate = Color(1,1,1)
					$Station.position = event.position
		elif event.get_button_index() == 2:
			$ShadowRail.visible = false
			selectedController = ""
			$Label.text = ""
			$Surveyor.modulate = Color(1,1,1)


func _on_surveyor_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		selectedController = "Surveyor"
		$Label.text = "Surveyor selected"
		$Surveyor.modulate = Color(0.0, 0.698, 0.0, 1.0)
