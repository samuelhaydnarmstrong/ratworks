shader_type canvas_item;

uniform float progress = 0.0;

const vec4 UNFINISHED_RAIL_COLOUR = vec4(0,0,0,0.2);
const vec4 FINISHED_RAIL_COLOUR = vec4(0.1,0.1,0.1,1);

void fragment() {
	// Imagine the Line2D spread flat, UV.x is the x coordinate (how far right) the current pixel is along that line
	float PIXEL_DISTANCE_ALONG_LINE_2D = UV.x;
	if (PIXEL_DISTANCE_ALONG_LINE_2D < progress) {
		COLOR = FINISHED_RAIL_COLOUR;
	} else {
		COLOR = UNFINISHED_RAIL_COLOUR;
	}
}