extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var patrol_node: Node2D
var patrol_points

# augmentation de la taille pour chaque beat
# retourne à 1 après quelques frame
var scale_platforme = 1
# pourcentage de décroissance par frame
export var DECROISSANCE_SCALE = 0.9
# max scale
export var MAX_SCALE = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func set_patrol_path(patrol_node):
	patrol_points = patrol_node.curve.get_baked_points()
	
func move(colone: int, nb_colone: int, largeur_ligne_pixel: int, hauteur_ligne_pixel: int):
	# largeur entre deux platforme en pixel 
	var largeur_platforme_pixel = largeur_ligne_pixel/nb_colone
	# nombre d'index entre deux position de platforme
	var largeur_patrole_index = len(patrol_points)/nb_colone
	
	# calcule de la position de l'index sur le path
	var patrol_index = largeur_patrole_index * (0.5 + colone)
	
	# on détermine le prochain point
	var target = patrol_points[patrol_index]
	if position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, patrol_points.size())
	# on va à la position
	position = patrol_points[patrol_index]
	position.y += hauteur_ligne_pixel * 0.3
	
	# augmentation de la taille de la platforme
	scale.x = MAX_SCALE
	scale.y = MAX_SCALE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale.x = clamp(scale.x*DECROISSANCE_SCALE, 1, MAX_SCALE)
	scale.y = clamp(scale.x*DECROISSANCE_SCALE, 1, MAX_SCALE)
