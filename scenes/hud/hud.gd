extends CanvasLayer

signal buy_tunnelling
signal place_first_track
signal open_inventory
signal garrison

func _on_track_pressed() -> void:
	place_first_track.emit()

func _on_tunnelling_pressed() -> void:
	buy_tunnelling.emit()

func _on_inventory_pressed() -> void:
	open_inventory.emit()

func _on_hud_refresh_timeout() -> void:	
	if (Globals.selectedNode):
		$SelectedFeature.text = Globals.selectedNode.name
	elif(Globals.selectedCell):
		$SelectedFeature.text = Globals.selectedCell
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

func _on_garrison_button_pressed() -> void:
	garrison.emit()
