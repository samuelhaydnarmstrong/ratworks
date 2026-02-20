extends Area2D

var desiredPosition: Vector2
var id: int
var inventory: Dictionary
var hoveredArea: Area2D
var type = "unit"
var speed = 0.1

@export var dialogueFile: DialogueResource

# Breaking encapsulation here
@onready var tileMap = get_node('../TileMapLayer')
@onready var fogOfWarTileMap = get_node('../FogOfWar')
@onready var main = get_node('..')
@onready var hud = get_node('../HUD')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	desiredPosition = self.position
	hud.garrison.connect(dock_unit)
	hud.time_of_day_changed.connect(time_of_day_changed)

func _process(_delta: float) -> void:
	if (self.position != desiredPosition and Globals.timeOfDay == "DAY"):
		if (inventory.get("horse") >= inventory.get("worker")):
			speed = 0.1 * 2
		
		self.position = self.position.move_toward(desiredPosition, speed)
	
	# There has GOT to be a better way.  This reveals the FOW under the unit and adjacent tiles.
	var x = floor(self.position.x / 64)
	var y = floor(self.position.y / 64)
	fogOfWarTileMap.set_cell(Vector2i(x-1, y-1),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(x-1, y),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(x-1, y+1),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(x, y-1),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(x, y),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(x, y+1),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(x+1, y-1),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(x+1, y),0,Vector2i(0,0))
	fogOfWarTileMap.set_cell(Vector2i(x+1, y+1),0,Vector2i(0,0))
	
	if (Globals.selectedNode != self):
		self.modulate = Color(1, 1, 1)

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() == true:
		if event.get_button_index() == 2:
			var mouseGridX = floor(event.position.x / 64)
			var mouseGridY = floor(event.position.y / 64)
			var selectedTileType = tileMap.get_cell_tile_data(Vector2i(mouseGridX,mouseGridY)).get_custom_data('name')
			if (Globals.selectedNode == self && selectedTileType != 'water'):
				desiredPosition = event.position

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		self.modulate = Color(0.0, 0.698, 0.0, 1.0)
		Globals.selectedNode = self

func _on_area_entered(area: Area2D) -> void:
	if(area.name == "Station"):
		hoveredArea = area

func _on_area_exited(area: Area2D) -> void:
	hoveredArea = null

func dock_unit():
	Globals.selectedNode = hoveredArea
	# Copy across everything from the unit into the Station inventory.
	var newInventory = Globals.selectedNode.inventory
	for item in newInventory.keys():
		newInventory[item] = newInventory[item] + inventory[item]
		
	self.queue_free()

func time_of_day_changed():
	if Globals.timeOfDay == "DAY":
		consume_food()

func consume_food() -> void:
	if(inventory.get("worker") > 0):
		if(inventory.get("food") > 0):
			inventory.set("food", inventory.get("food") - 1)
		else:
			inventory.set("worker", inventory.get("worker") - 1)
			if (inventory.get("worker") == 0):
				DialogueManager.show_dialogue_balloon(dialogueFile, 'unit_starved')
				self.queue_free()
		
