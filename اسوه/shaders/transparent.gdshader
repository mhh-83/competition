shader_type canvas_item;

void fragment() {
	if(texture(TEXTURE, UV).a <=.5){
		COLOR.a = 0.0;
	}
}
