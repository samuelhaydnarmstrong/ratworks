extends Node

var selectedNode: Node
var selectedCell: String

func lerp(start, end, t):
	return start * (1.0 - t) + end * t
	
func lerp_point(p0, p1, t):
	return Vector2(lerp(p0.x, p1.x, t),lerp(p0.y, p1.y, t))

func diagonal_distance(p0, p1):
	var dx = p1.x - p0.x
	var dy = p1.y - p0.y
	return max(abs(dx), abs(dy));

func round_point(p):
	return Vector2(round(p.x), round(p.y))

func pixelsToGrid(pixelPosition):
	return floor(pixelPosition / 64)

const EMPTY_INVENTORY = {"money": 0, "food": 0, "worker": 0, "horse": 0}

var timeOfDay = 'DAY'
