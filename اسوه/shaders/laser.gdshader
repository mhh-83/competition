shader_type canvas_item;
uniform float speed = 10.0;
uniform float min_size = 1.0;
uniform float max_size = 10.0;
uniform float curve_size = 10.0;
uniform float outline_size = 10.0;
uniform vec4 color :source_color;
uniform vec4 color2 :source_color;
void fragment() {
	float glow = 0.1 / SCREEN_PIXEL_SIZE.x * sin(TIME * speed);
	glow = clamp(glow, min_size, max_size);
	float curve = 1.0 - abs(UV.y - 0.5) * curve_size;
	float i = clamp(curve, .6, 1.0);
	i += clamp((glow + curve) / glow, 0.0, 1.0);
	if(curve >  - outline_size){
		COLOR = i * color;
	}else{
		COLOR = color2 * i;
	}
}
