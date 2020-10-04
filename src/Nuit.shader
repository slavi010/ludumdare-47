shader_type canvas_item;

void fragment(){
	COLOR = texture(TEXTURE, UV); //read from texture
 	COLOR.b = 0.45;
	COLOR.r -= 0.45;
	COLOR.g -= 0.45;
}
