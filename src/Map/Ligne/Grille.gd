extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var Platforme = load("res://Map/Obstacle/Platforme.tscn")
# les platformes 
var grille: Array = []

# ligne
var lignes: Array = []

# taille de l'écrant
var TAILLE_ECRANT = get_viewport_rect().size

# hauteur entre deux ligne en pixel
var HAUTEUR_LIGNE = 50
# largeur ligne en pixel
var LARGEUR_LIGNE = 1024
# largeur d'une platforme en par rapport à celle de base
var LARGEUR_PLATFORME_SCALE = 1
# nombre de colone par ligne
var NB_COLONE = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	# NB_BLOCK_PAR_LIGNE = TODO
	# HAUTEUR_LIGNE = TODO
	# LARGEUR_LIGNE = TODO
	# NB_COLONE = TODO
	LARGEUR_PLATFORME_SCALE = 10/NB_COLONE
	
	# init lignes
	for i in range(1, 5 + 1):
		lignes.append(get_node("Ligne_" + str(i)))
	
	# init case grille à none
	for ligne in range(5):
		grille.append([])
		for colone in range(NB_COLONE): # CHANGE 5
			grille[ligne].append(null)
	
	# test platforme
	add_platforme(1, 0)
	add_platforme(1, 1)
	add_platforme(1, -1)
	
	# connect à chaque beat
	$"../Grille".connect("beat", self, "_on_Main_beat")
	

# Ajoute une nouvelle platforme 
# la ligne de la platforme et sa colone (-1 pour tout à droite)
# si déjà objet, ne fait rien
func add_platforme(ligne: int, colone: int = -1):
	if colone < 0:
		colone = NB_COLONE + colone
	
	var platforme = Platforme.instance()
	lignes[ligne].add_child(platforme)
	platforme.scale.x = LARGEUR_PLATFORME_SCALE
	platforme.set_patrol_path(lignes[ligne])
	platforme.move(colone, NB_COLONE, LARGEUR_LIGNE)
	

func get_position_case_grille(ligne: int, colone: int):
	return ((colone + 0.5)) #TODO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
#	var speed = 1 
#	position = position.move_toward(Vector2(0,0), delta * speed)

# A chaque resception d'un beat
func _on_Main_beat():
	# pour chaque platforme, on les bouge à droite
	for colone in range(NB_COLONE):
		for ligne in range(5):
			var platforme = grille[ligne][colone]
			if platforme != null:
				if colone == 0:
					# on supprime la platforme (hort écran) TODO
					pass
				else:
					grille[ligne][colone - 1] = platforme
					grille[ligne][colone] = null
					platforme.move(colone - 1, NB_COLONE, LARGEUR_LIGNE)
