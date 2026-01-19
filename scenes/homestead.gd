extends Area2D

@export var dialogueFile: DialogueResource
@export var settlementName: String
@export var dialogueFileSection: String

func _ready() -> void:
	$Label.text = settlementName

func _on_area_entered(area: Area2D) -> void:
	if area.name == 'LastRailPoint':
		DialogueManager.show_dialogue_balloon(dialogueFile, 'settlement_connected')
	if dialogueFile and dialogueFileSection:
		DialogueManager.show_dialogue_balloon(dialogueFile, dialogueFileSection)
