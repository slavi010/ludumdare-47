shader_type canvas_item;
uniform float angle;
uniform float radius;

varying vec2 numero_ligne; //Variable 

void vertex(){
	//A supprimer a la fin du projet => fonctions qui peuvent être utiles a des trucs mais pas pour l'instant
	/*if(VERTEX.x <= 0.0){
		VERTEX.x += VERTEX.y - 64.0/2.0;
	} else {
		VERTEX.x -= VERTEX.y - 64.0/2.0;
	}*/
	/*world_position = (global_transform * vec4(VERTEX, 0.0, 1.0)).xy;
	if(TIME < start_time){
		VERTEX = vec2(-VERTEX.x*cos(angle*(TIME)) - VERTEX.y*sin(angle*(TIME)), -VERTEX.x*sin(angle*(TIME)) + VERTEX.y*cos(angle*(TIME)));
		VERTEX.y -= 50.0*(TIME-start_time);
	}
	if(TIME > end_time){
		VERTEX = vec2(-VERTEX.x*cos(angle*(TIME-end_time)) - VERTEX.y*sin(angle*(TIME-end_time)), -VERTEX.x*sin(angle*(TIME-end_time)) + VERTEX.y*cos(angle*(TIME-end_time)));
		VERTEX.y += 50.0*(TIME-end_time);
	}*/
	
	//rotation du sprite sur lui même
	VERTEX = vec2(VERTEX.x*cos(angle+(TIME)) + VERTEX.y*sin(angle+(TIME)), -VERTEX.x*sin(angle+(TIME)) + VERTEX.y*cos(angle+(TIME)));
	//Rotation autour du centre (avec rayon = 100 ici)
	VERTEX += vec2(cos(TIME)*radius,-sin(TIME)*radius);
}