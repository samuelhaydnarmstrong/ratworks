extends CanvasLayer

signal buy_tunnelling
signal place_first_track
signal open_inventory
signal garrison
signal time_of_day_changed

func _ready():
	$SelectedFeature.text = ""
	$Inventory.visible = false
	$RecruitmentButton.visible = false

func _on_track_pressed() -> void:
	place_first_track.emit()

func _on_tunnelling_pressed() -> void:
	buy_tunnelling.emit()

func _on_inventory_pressed() -> void:
	open_inventory.emit()

func _on_hud_refresh_timeout() -> void:	
	if(Globals.selectedCell):
		$SelectedFeature.text = Globals.selectedCell
	else:
		$SelectedFeature.text = ""
		
	# Node takes precidence over Cell since they use the same Label
	if (Globals.selectedNode):
		$SelectedFeature.text = Globals.selectedNode.name
	else:
		$SelectedFeature.text = ""
		
	if (Globals.selectedNode and Globals.selectedNode.name == "Station"):
		$StationOptions.visible = true
	else:
		$StationOptions.visible = false

	if(Globals.selectedNode and Globals.selectedNode.get("inventory")):
		$InventoryButton.visible = true
	else:
		$InventoryButton.visible = false

	if(Globals.selectedNode and Globals.selectedNode.get("hoveredArea")):
		$GarrisonButton.visible = true
	else:
		$GarrisonButton.visible = false
		
	if (Globals.selectedNode and Globals.selectedNode.get("type") == "unit"):
		$DisbandButton.visible = true
	else:
		$DisbandButton.visible = false
		
	if (Globals.selectedNode and Globals.selectedNode.get("type") == "settlement"):
		$RecruitmentButton.visible = true
	else:
		$RecruitmentButton.visible = false

func _on_garrison_button_pressed() -> void:
	garrison.emit()

func _on_disband_button_pressed() -> void:
	if Globals.selectedNode:
		Globals.selectedNode.queue_free()

func _on_recruitment_button_pressed() -> void:
	$Popup.popup()

func _on_time_of_day_timer_timeout() -> void:
	if Globals.timeOfDay == "DAY":
		Globals.timeOfDay = "NIGHT"
		$TimeOfDayLabel.text = "NIGHT"
	else:
		Globals.timeOfDay = "DAY"
		$TimeOfDayLabel.text = "DAY"
	time_of_day_changed.emit()
