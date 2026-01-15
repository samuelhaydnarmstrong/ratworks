extends Node

var flagToSet = 0
var start
var end

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() == true:
		print("Click event")
		# get_viewport().get_visible_rect().size.x
		var x = floor(event.position.x / 64)
		var y = floor(event.position.y / 64)
		
		if (flagToSet == 1):
			print("Setting start")
			start = event.position
			$TileMapLayer.set_cell(Vector2i(x, y), 1, Vector2i(2,2),1)
			flagToSet = -1;
		elif (flagToSet == 2):
			print("Setting end")
			end = event.position
			$TileMapLayer.set_cell(Vector2i(x, y), 1, Vector2i(2,2),1)
			flagToSet = -1;

func _on_flag_1_button_pressed() -> void:
	flagToSet = 1


func _on_flag_2_button_pressed() -> void:
	flagToSet = 2


func _on_draw_line_button_pressed() -> void:
	var line := Line2D.new()
	line.width = 3
	line.default_color = Color.CYAN
	line.add_point(start)
	line.add_point(end)
	line.z_index = 10
	add_child(line)
