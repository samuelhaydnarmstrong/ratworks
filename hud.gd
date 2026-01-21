extends CanvasLayer

signal buy_tunnelling
signal place_first_track
signal open_inventory

func _on_main_update_selected_feature(selectedFeature: Dictionary) -> void:
	if selectedFeature:
		$SelectedFeature.text = str(selectedFeature.name)
	else:
		$SelectedFeature.text = ""

	if (selectedFeature && selectedFeature.name == "Station"):
		$StationOptions.visible = true
	else:
		$StationOptions.visible = false

func _on_track_pressed() -> void:
	place_first_track.emit()

func _on_main_track_started() -> void:
	$StationOptions/Track.visible = false

func _on_tunnelling_pressed() -> void:
	buy_tunnelling.emit()

func _on_inventory_pressed() -> void:
	open_inventory.emit()

func _on_money_refresh_timeout() -> void:
	$Money.text = str(Globals.money)
