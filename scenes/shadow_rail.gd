# Most of this file is thanks to https://www.redblobgames.com/grids/line-drawing/
# Now because of how the tile walking works it's still possible to have a path that
# goes over an invalid tile.  Perhaps there's an improvement in the future!

# Lots of optimisation to be done here around separating out the slower checks
# and only doing them on cell changes

extends Line2D

@onready var main = get_node('..')
@onready var tileMapLayer = get_node('../TileMapLayer')
@onready var fogOfWar = get_node('../FogOfWar')

func _on_timer_timeout() -> void:
	if (main.isPlacingRail):
		var shadowStartX = Globals.pixelsToGrid(self.get_point_position(0).x)
		var shadowStartY = Globals.pixelsToGrid(self.get_point_position(0).y)
		var shadowEndX = Globals.pixelsToGrid(self.get_point_position(1).x)
		var shadowEndY = Globals.pixelsToGrid(self.get_point_position(1).y)
		var isDangerousRoute = line(Vector2(shadowStartX, shadowStartY), Vector2(shadowEndX, shadowEndY))
		var lengthOfShadowRail = self.get_point_position(0).distance_to(get_viewport().get_mouse_position())
		if (lengthOfShadowRail > Globals.money or isDangerousRoute):
			self.set_default_color(Color(1.0, 0.0, 0.0, 0.2))
			main.isRailValid = false
		else:
			self.set_default_color(Color(0, 1, 0, 0.2))
			main.isRailValid = true

func line(p0, p1):
	var N = Globals.diagonal_distance(p0, p1)
	var step = 0
	var isDangerous = false;
	while step <= N:
		var t = 0.0 if N == 0 else step / N
		var cellToCross = Globals.round_point(Globals.lerp_point(p0, p1, t))
		var isFog = fogOfWar.get_cell_tile_data(cellToCross).get_custom_data('isFog')
		var biome = tileMapLayer.get_cell_tile_data(cellToCross).get_custom_data('name')
		if (biome == "water" or isFog or (biome == "mountain" and !main.hasTunnellingSkill)):
			return true;
		step+=1
	return isDangerous;
