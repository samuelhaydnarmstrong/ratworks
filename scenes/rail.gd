extends Line2D
	
var progress = 0;
var length = 0

func _on_rail_animation_timer_timeout() -> void:
	print("Setting progress", progress)
	if (progress < 1):
		progress+= 0.05
	elif (progress > 1):
		progress = 1
	material.set_shader_parameter('progress', progress)
	
	if (progress == 1):
		$RailAnimationTimer.stop()

# This function adds the new point but also recalculates the construction progress so that the
# animation is smooth with new track being laid.
func add_point_override(newPoint: Vector2) -> void:
	if self.get_point_count() > 0:
		var lengthAddition = self.get_point_position(self.get_point_count()-1).distance_to(newPoint)
		var completedLength = 0 if progress == 0 else length * progress
		print('Completed Length ' + str(completedLength) + " of full length: " + str(length))
		progress = completedLength / (length+lengthAddition)
		material.set_shader_parameter('progress', progress)
		length = length + lengthAddition
	self.add_point(newPoint)
	$RailAnimationTimer.start()

# We don't need this anymore but it's a good example of some animation logic using tweens
#func ready():
	#var tween = create_tween()
	#var MIN_PROG = 0.0
	#var MAX_PROG = 1.0
	#var TIME_TO_ANIMATE = 5.0
	#tween.tween_method(tween_shader_parameter.bind("progress"), MIN_PROG, MAX_PROG, TIME_TO_ANIMATE).set_trans(Tween.TRANS_LINEAR)
#func tween_shader_parameter(value: Variant, param: String):
	#material.set_shader_parameter(param, value)
