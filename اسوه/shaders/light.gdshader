shader_type canvas_item;
uniform int waite_time = 1;
uniform float speed =50.0;
uniform bool down = false;
uniform bool up = false;
uniform bool right = false;
uniform bool left = false;
uniform vec3 color : source_color;
uniform float width_ratio : hint_range(0.01, 1.0, 0.01) = 0.0;
uniform float skew : hint_range(-1.0, 1.0, 0.01) = 0.2;
uniform float space : hint_range(0.0, 1.0, 0.01);
uniform int num : hint_range(1, 10, 1);
uniform vec2 move_range = vec2(0.0, 100.0);
uniform float move_speed = 1.0;
void vertex(){
	VERTEX += sin(TIME * move_speed) * move_range;
}
void fragment() {
	float delta = float(int(TIME * speed) % (((100 * waite_time) + ((num - 1) * 100)) + int(skew * 100.0))) * 0.01;
	float s = UV.x * skew;
	if(up){
		for(int x = 1; x <= num; x++){
			if((UV.y - 1.0) + s + (float(x - 1) * (space + width_ratio)) < ((width_ratio * float(x)))  - delta && (UV.y - 1.0) + (float(x - 1) * (space + width_ratio)) > ((width_ratio * float(x - 1))) - delta - s){
				COLOR += vec4(color, 0.0);
			}
		}
	}
	else if(down){
		for(int x = 1; x <= num; x++){
			if(UV.y + s + (float(x - 1) * (space + width_ratio)) < ((width_ratio * float(x))) + delta && UV.y + (float(x - 1) * (space + width_ratio)) > ((width_ratio * float(x - 1))) + delta - s){
				COLOR += vec4(color, 0.0);
			}
		}
	}
	else if(left){
		s = UV.y * skew;
		for(int x = 1; x <= num; x++){
			if((UV.x - 1.0) + s + (float(x - 1) * (space + width_ratio)) < ((width_ratio * float(x))) - delta && (UV.x - 1.0) + (float(x - 1) * (space + width_ratio)) > ((width_ratio * float(x - 1))) - delta - s){
				COLOR += vec4(color, 0.0);
			}
		}
	}
	else if(right){
		s = UV.y * skew;
		for(int x = 1; x <= num; x++){
			if(UV.x + s + (float(x - 1) * (space + width_ratio)) < ((width_ratio * float(x))) + delta && UV.x + (float(x - 1) * (space + width_ratio)) > ((width_ratio * float(x - 1))) + delta - s){
				COLOR += vec4(color, 0.0);
			}
		}
	}
}

