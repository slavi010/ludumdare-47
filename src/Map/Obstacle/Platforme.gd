extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var patrol_node: Node2D
var patrol_points

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_patrol_path(patrol_node):
	patrol_points = patrol_node.curve.get_baked_points()
	
func move(colone: int, nb_colone: int, largeur_ligne_pixel: int):
	# largeur entre deux platforme en pixel 
	var largeur_platforme_pixel = largeur_ligne_pixel/nb_colone
	# nombre d'index entre deux position de platforme
	var largeur_patrole_index = len(patrol_points)/nb_colone
	
	# calcule de la position de l'index sur le path
	var patrol_index = largeur_patrole_index * (0.5 + colone)
	
	var target = patrol_points[patrol_index]
	if position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
	position = patrol_points[patrol_index]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
