extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		

func _input(event):
	if event is InputEventMouseButton:
		# get_viewport().get_visible_rect().size.x
		var x = floor(event.position.x / 64)
		var y = floor(event.position.y / 64)
		print("Cell clicked is " + str(x) + " " + str(y))
		$TileMapLayer.set_cell(Vector2i(x, y), 1, Vector2i(2,2),1)
