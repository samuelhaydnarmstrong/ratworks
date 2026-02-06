extends Area2D

@export var dialogueFile: DialogueResource
@export var settlementName: String
@export var dialogueFileSection: String

var inventory = Globals.EMPTY_INVENTORY.duplicate()
var type = "settlement"

func _ready() -> void:
	$Label.text = settlementName

func _on_area_entered(area: Area2D) -> void:
	if area.name == 'LastRailPoint':
		DialogueManager.show_dialogue_balloon(dialogueFile, 'settlement_connected')
	if dialogueFile and dialogueFileSection:
		DialogueManager.show_dialogue_balloon(dialogueFile, dialogueFileSection)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		Globals.selectedNode = self
