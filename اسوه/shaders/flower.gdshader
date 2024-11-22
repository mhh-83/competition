shader_type canvas_item;
uniform float range = 100.0;
uniform vec2 speed = vec2(1.0, 0.0);
uniform float pivot = 1.0;
uniform float dir : hint_range(-1.0, 1.0, 1.0);
void vertex(){
	VERTEX += vec2(sin(TIME * speed.x * dir) * range * (UV.y - pivot), sin(TIME * speed.y * dir) * range * UV.x);
}
