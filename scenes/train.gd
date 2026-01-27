extends Area2D

@export var Station: Node2D
@export var Rail: Line2D
@export var main: Node

var current_index := 0
var forward := true

func move_train():
	var last_index := Rail.get_point_count() - 1

	# Reverse direction at ends
	if forward and current_index == last_index:
		forward = false
	elif not forward and current_index == 0:
		forward = true

	# Compute next index
	var next_index := current_index + (1 if forward else -1)

	# Tween to next point
	var tween := create_tween()
	var train_speed := position.distance_to(Rail.get_point_position(next_index))/10
	tween.tween_property(self, "position", Rail.get_point_position(next_index), train_speed)

	# Update index AFTER deciding next_index
	current_index = next_index

	# Continue animation
	tween.tween_callback(move_train)

func _on_main_track_started() -> void:
	position = Station.position
	move_train()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		Globals.selectedNode = self
