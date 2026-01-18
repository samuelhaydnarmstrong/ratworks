extends CanvasLayer

signal buy_surveyor
signal place_first_track

func _on_surveyor_button_pressed() -> void:
	buy_surveyor.emit()

func update_money(newMoney):
	$Money.text = str(newMoney)

func _on_main_update_selected_feature(selectedFeature: Dictionary) -> void:
	if selectedFeature:
		$SelectedFeature.text = str(selectedFeature.name)
	else:
		$SelectedFeature.text = ""

	if (selectedFeature && selectedFeature.name == "Station"):
		$StationOptions.visible = true
	else:
		$StationOptions.visible = false

func _on_main_game_won() -> void:
	$SelectedFeature.text = "You win!"

func _on_track_pressed() -> void:
	place_first_track.emit()


func _on_main_track_started() -> void:
	$StationOptions/Track.visible = false
