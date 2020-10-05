shader_type canvas_item;

void fragment(){
	COLOR = texture(TEXTURE,UV);
	COLOR.r -= 0.65;
	COLOR.g -= 0.45;
	COLOR.b -= 0.35;
}