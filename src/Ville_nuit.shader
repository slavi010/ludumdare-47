shader_type canvas_item;

void fragment(){
	COLOR = texture(TEXTURE, UV);
	COLOR.r -= 0.2;
	COLOR.g -= 0.45;
	COLOR.b += 0.0;
	COLOR -= vec4(0.2,0.2,0.2,0.0);
}