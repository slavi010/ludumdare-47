extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# le LEVEL
# 0 = rien
# 1 = platforme
var level = \
[   #lignes
	#1  2  3  4  5
	[0, 0, 0, 0, 0],
]
# l'index de la prochaine colone du level à afficher
var level_index = 0

var Platforme = load("res://Map/Obstacle/Platforme.tscn")
# les platformes 
var grille: Array = []

# ligne
var lignes: Array = []
	
# taille de l'écrant
var TAILLE_ECRANT = get_viewport_rect().size

# hauteur entre deux ligne en pixel
var HAUTEUR_LIGNE = 75
# largeur ligne en pixel
var LARGEUR_LIGNE = 1024
# largeur d'une platforme en par rapport à celle de base
var LARGEUR_PLATFORME_SCALE = 1
# nombre de colone par ligne
var NB_COLONE = 20


# Called when the node enters the scene tree for the first time.
func _ready():
	# NB_BLOCK_PAR_LIGNE = TODO
	# HAUTEUR_LIGNE = TODO
	# LARGEUR_LIGNE = TODO
	# NB_COLONE = TODO
	LARGEUR_PLATFORME_SCALE = 10.0/NB_COLONE
	
	
	# init lignes
	for i in range(1, 5 + 1):
		lignes.append(get_node("Ligne_" + str(i)))
	
	for ligne in range(5):
		lignes[ligne].position.y = HAUTEUR_LIGNE*ligne
	
	# init case grille à none
	for ligne in range(5):
		grille.append([])
		for colone in range(NB_COLONE): # CHANGE 5
			grille[ligne].append(null)
	
	# test platforme
	
	# connect à chaque beat
	$"../".connect("beat", self, "_on_Main_beat")
	

# Ajoute une nouvelle platforme 
# la ligne de la platforme et sa colone (-1 pour tout à droite)
# si déjà objet, ne fait rien
func add_platforme(ligne: int, colone: int = -1):
	if colone < 0:
		colone = NB_COLONE + colone
	
	var platforme = Platforme.instance()
	grille[ligne][colone] = platforme
	lignes[ligne].add_child(platforme)
	platforme.SCALE_X = LARGEUR_PLATFORME_SCALE
	platforme.set_patrol_node(lignes[ligne])
	platforme.move(colone, NB_COLONE, LARGEUR_LIGNE, HAUTEUR_LIGNE)
	

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
			var item = grille[ligne][colone]
			if item != null:
				if colone == 0:
					remove_item_grille(ligne, colone)
					pass
				else:
					grille[ligne][colone - 1] = item
					item.move(colone - 1, NB_COLONE, LARGEUR_LIGNE, HAUTEUR_LIGNE)
				grille[ligne][colone] = null
	# si dernière colone
	set_colone(NB_COLONE-1)

func remove_item_grille(ligne: int, colone: int):
	var item = grille[ligne][colone]
	if item != null:
		item.hide()
		lignes[ligne].remove_child(item)

func get_next_colone(lvl: Array) -> Array:
	var col = lvl[level_index]
	level_index += 1
	if level_index >= len(lvl):
		level_index = 0
	return col

func set_colone(colone: int):
	var col: Array = get_next_colone(level)
	for ligne in range(5):
		match col[ligne]:
			0: # vide
				grille[ligne][colone] = null
			1: # platforme
				add_platforme(ligne, colone)
		
func init_level():
	for colone in range(NB_COLONE):
		for ligne in range(5):
			remove_item_grille(ligne, colone)
		set_colone(colone)

# retourne les objets d'une colone de la grille
func get_colone_grille(colone: int):
	var col = []
	for ligne in range(5):
		col.append(grille[ligne][colone])
	return col

func set_ext_level():
	$"../Rythme".wait_time = 0.35
	level = \
	[   #lignes
		#1  2  3  4  5
		[1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1],
		[1, 0, 1, 0, 1],
		[1, 0, 0, 0, 0],
		[1, 0, 0, 0, 0],
		[1, 0, 0, 0, 0],
		[1, 1, 0, 0, 0],
		[1, 0, 0, 1, 0],
		[1, 0, 0, 0, 0],
		[1, 0, 0, 0, 1],
		[1, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 1, 0, 0],
		[0, 0, 1, 0, 0],
		[0, 0, 1, 0, 0],
		[0, 0, 1, 0, 0],
		[0, 0, 1, 0, 0],
		[1, 0, 1, 0, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 1, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0],
	]
	init_level()

func set_level_tuto():
	$"../Rythme".wait_time = 1
	level = \
	[   #lignes
		#1  2  3  4  5
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 1, 1],
		[0, 0, 0, 1, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
	]
	init_level()
