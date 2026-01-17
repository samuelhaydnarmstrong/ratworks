extends Area2D

var desiredPosition: Vector2

var WATER = Vector2i(0,0)

# Breaking encapsulation here
@onready var tileMap = get_node('../TileMapLayer')
@onready var fogOfWarTileMap = get_node('../FogOfWar')
@onready var selectedUnitLabel = get_node('../SelectedUnitLabel')
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	desiredPosition = self.position

func _process(_delta: float) -> void:
	if (self.position != desiredPosition):
		self.position = self.position.move_toward(desiredPosition,0.4)
	
	# There has GOT to be a better way.  This reveals the FOW under the surveyor and adjacent tiles.
	var surveyorX = floor(self.position.x / 64)
	var surveyorY = floor(self.position.y / 64)
	fogOfWarTileMap.set_cell(Vector2i(surveyorX-1, surveyorY-1),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(surveyorX-1, surveyorY),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(surveyorX-1, surveyorY+1),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(surveyorX, surveyorY-1),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(surveyorX, surveyorY),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(surveyorX, surveyorY+1),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(surveyorX+1, surveyorY-1),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(surveyorX+1, surveyorY),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(surveyorX+1, surveyorY+1),0,Vector2i(0,0))

func _input(event):
	var mouseGridX = floor(event.position.x / 64)
	var mouseGridY = floor(event.position.y / 64)
	var selectedTileType = tileMap.get_cell_atlas_coords(Vector2i(mouseGridX,mouseGridY))
	
	if event is InputEventMouseButton and event.is_pressed() == true:
		if event.get_button_index() == 2:
			if (selectedUnitLabel.text == 'Surveyor' && selectedTileType != WATER):
				desiredPosition = event.position
		elif event.get_button_index() == 1:
			selectedUnitLabel.text = ''
			self.modulate = Color(1, 1, 1)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		self.modulate = Color(0.0, 0.698, 0.0, 1.0)
		selectedUnitLabel.text = 'Surveyor'
