extends Node2D


# le LEVEL
# 0 = rien
# 1 = platforme
# 2 = mur
# 3 = tunnel
# 4 = break wall
# 5 = vent
# 6 = fleure

signal halo
signal musique_charge(biome, is_monde_interieur)
signal FIN

# l'index de la prochaine colone du level à afficher
var level_index = 0

var Platforme = load("res://Map/Obstacle/Platforme.tscn")
var Mur = load("res://Map/Obstacle/Mur.tscn")
var Tunnel = load("res://Map/Obstacle/Tunnel.tscn")
var Fleure = load("res://Map/Obstacle/Fleure.tscn")
var BreakWall = load("res://Map/Obstacle/BreakWall.tscn")
var Wind = load("res://Map/Obstacle/Wind.tscn")

var SHADERS = [preload("res://Nuit.shader"), preload("res://Ville_nuit.shader"), preload("res://Ocean_nuit.shader")]

# LA GRILLE 
var grille: Array = []

# ligne
var lignes: Array = []
	
# taille de l'écrant
var TAILLE_ECRANT = Vector2(1024, 600)

# hauteur entre deux ligne en pixel
var HAUTEUR_LIGNE = 65
# largeur ligne en pixel
var LARGEUR_LIGNE = 1024
# largeur d'une platforme en par rapport à celle de base
var LARGEUR_PLATFORME_SCALE = 1
# nombre de colone par ligne
var NB_COLONE = 10

var centre_planet

var show_halo: bool = false
var index_deplacement_halo = 0

var is_space: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	centre_planet = Vector2(1024/2, 600*10)
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
	$"../../".connect("beat", self, "_on_Main_beat")
	$"../Dodo".connect("traversTunnel", self, "_on_Dodo_traversTunnel")
	$"../Dodo".connect("dodoTombe", self, "_on_Dodo_murHit")
	$"../Dodo".connect("dodoHalo", self, "_on_Dodo_halo")
	

# Ajoute une nouvelle platforme 
# la ligne de la platforme et sa colone (-1 pour tout à droite)
# si déjà objet, ne fait rien
func add_platforme(ligne: int, colone: int = -1, biome: int = 0):
	if colone < 0:
		colone = NB_COLONE + colone
	
	var platforme = Platforme.instance()
	grille[ligne][colone] = platforme
	lignes[ligne].add_child(platforme)
	platforme.SCALE_X = LARGEUR_PLATFORME_SCALE
	platforme.set_patrol_node(lignes[ligne])
	platforme.set_biome(biome)
	platforme.monde_interieur = monde_interieur
	platforme.move(colone, NB_COLONE, LARGEUR_LIGNE, HAUTEUR_LIGNE)
	
	if monde_interieur :
		platforme.get_node("AnimatedSprite").material.shader = SHADERS[biome]
	else:
		platforme.get_node("AnimatedSprite").material.shader = null
	
# Ajoute un nouveau mur 
# la ligne de la mur et sa colone (-1 pour tout à droite)
# si déjà objet, ne fait rien
func add_mur(ligne: int, colone: int = -1, biome: int = 0):
	if colone < 0:
		colone = NB_COLONE + colone
	
	var mur = Mur.instance()
	grille[ligne][colone] = mur
	lignes[ligne].add_child(mur)
	mur.SCALE_X = LARGEUR_PLATFORME_SCALE
	mur.set_patrol_node(lignes[ligne])
	mur.set_biome(biome)
	mur.monde_interieur = monde_interieur
	mur.move(colone, NB_COLONE, LARGEUR_LIGNE, HAUTEUR_LIGNE)	
	
	if monde_interieur :
		mur.get_node("AnimatedSprite").material.shader = SHADERS[biome]
	else:
		mur.get_node("AnimatedSprite").material.shader = null

# Ajoute un nouveau tunnel
# la ligne du  tunnel et sa colone (-1 pour tout à droite)
# si déjà objet, ne fait rien
func add_tunnel(ligne: int, colone: int = -1):
	if colone < 0:
		colone = NB_COLONE + colone
	
	var tunnel = Tunnel.instance()
	grille[ligne][colone] = tunnel
	lignes[ligne].add_child(tunnel)
	tunnel.SCALE_X = LARGEUR_PLATFORME_SCALE
	tunnel.set_patrol_node(lignes[ligne])
	tunnel.monde_interieur = monde_interieur
	tunnel.move(colone, NB_COLONE, LARGEUR_LIGNE, HAUTEUR_LIGNE)

# Ajoute une nouvelle fleure
# la ligne du  tunnel et sa colone (-1 pour tout à droite)
# si déjà objet, ne fait rien
func add_fleure(ligne: int, colone: int = -1):
	if colone < 0:
		colone = NB_COLONE + colone
	
	var fleure = Fleure.instance()
	grille[ligne][colone] = fleure
	lignes[ligne].add_child(fleure)
	fleure.SCALE_X = LARGEUR_PLATFORME_SCALE
	fleure.set_patrol_node(lignes[ligne])
	fleure.monde_interieur = monde_interieur
	fleure.move(colone, NB_COLONE, LARGEUR_LIGNE, HAUTEUR_LIGNE)
	
# Ajoute un nouveau break wall
# la ligne du break wall et sa colone (-1 pour tout à droite)
# si déjà objet, ne fait rien
func add_break_wall(ligne: int, colone: int = -1):
	if colone < 0:
		colone = NB_COLONE + colone
	
	var brealWall = BreakWall.instance()
	grille[ligne][colone] = brealWall
	lignes[ligne].add_child(brealWall)
	brealWall.SCALE_X = LARGEUR_PLATFORME_SCALE
	brealWall.set_patrol_node(lignes[ligne])
	brealWall.monde_interieur = monde_interieur
	brealWall.move(colone, NB_COLONE, LARGEUR_LIGNE, HAUTEUR_LIGNE)
	
# Ajoute un nouveau wind
# la ligne du wind et sa colone (-1 pour tout à droite)
# si déjà objet, ne fait rien
func add_wind(ligne: int, colone: int = -1):
	if colone < 0:
		colone = NB_COLONE + colone
	
	var wind = Wind.instance()
	grille[ligne][colone] = wind
	lignes[ligne].add_child(wind)
	wind.SCALE_X = LARGEUR_PLATFORME_SCALE
	wind.set_patrol_node(lignes[ligne])
	wind.monde_interieur = monde_interieur
	wind.move(colone, NB_COLONE, LARGEUR_LIGNE, HAUTEUR_LIGNE)

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
	load_colone_chunk(NB_COLONE-1)
	
	if show_halo:
		$"../Halo".position.x -= 1024/NB_COLONE
		index_deplacement_halo += 1
		
		if index_deplacement_halo > NB_COLONE - $"../Dodo".COLONE_JOUEUR:
			on_halo()

func remove_item_grille(ligne: int, colone: int):
	var item = grille[ligne][colone]
	if item != null:
		item.hide()
		lignes[ligne].remove_child(item)

# retourne les objets d'une colone de la grille
func get_colone_grille(colone: int):
	var col = []
	for ligne in range(5):
		col.append(grille[ligne][colone])
	return col
	

func _on_Dodo_traversTunnel():
	if not $"../Introduction".intro:
		if not monde_interieur:
			actu_chunk += 1
			if actu_chunk >= len(all_chunk) - 1:
				actu_chunk = 2
		load_chunk(actu_chunk, false)
		$"../Rythme".start()
	else:
		if not $"../Introduction".flag_passed_dialogue[5] and \
			actu_chunk == 1 and not monde_interieur:
			$"../Introduction".show_dialogue(5)
		actu_chunk += 1
		load_chunk(actu_chunk, false)
#		$"../Rythme".start()

func _on_Dodo_murHit():
	$"../Dodo".is_tombe = false

	if not is_space:
		$"../Rythme".start()
		load_chunk(actu_chunk, true)
		$"../Dodo".position = $"../Dodo".get_vecteur_position_ligne($"../Dodo".position_ligne)
	else:
		# FIN
		emit_signal("FIN")

# le LEVEL
# 0 = rien
# 1 = platforme
# 2 = mur
# 3 = tunnel
# 4 = break wall
# 5 = vent

var actu_chunk = 2
var chunk_position_colone = 0
var monde_interieur: bool = false
var all_chunk = [
	[ # un chunk tutoriel
		[0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 6, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 1, 2],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 1, 2],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
	],
	[ # un chunk tutoriel
		#Planer
		[0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 1, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 1, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
	],
	[ 
		[0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 1, 1],
		[0, 0, 0, 1, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 1, 2, 0],
		[0, 0, 1, 2, 0],
		[0, 0, 0, 0, 0],
		[2, 2, 2, 0, 0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[1, 2, 1, 0, 1],
		[0, 0, 1, 0, 1],
		[0, 0, 1, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
	],
	[
		[0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 1, 2],
		[0, 0, 0, 0, 0],
		[0, 0, 1, 0, 0],
		[0, 0, 1, 0, 0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 4],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 0],
		[0, 0, 1, 0, 0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 1, 2, 2],
		[0, 0, 0, 0, 1],
		[0, 1, 2, 2, 2],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 1],
	],
	[ 
		[0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 0],
		[0, 0, 1, 0, 0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 1, 2, 2],
		[0, 0, 0, 0, 1],
		[0, 1, 2, 2, 2],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 4],
		[0, 0, 0, 0, 4],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0],
		[0, 1, 2, 0, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 0],
		[2, 2, 2, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
	],
	[ 
		[0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
	],
	[ 
		[0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 1, 1],
		[0, 0, 0, 1, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 1, 2, 0],
		[0, 0, 1, 2, 0],
		[0, 0, 0, 0, 0],
		[2, 2, 2, 0, 0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 2, 2, 1, 1],
		[0, 0, 0, 1, 1],
		[0, 0, 0, 1, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
	],
	[ # un chunk 
		# options {biome}
		[0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 1, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 1, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 4, 1, 0],
		[0, 0, 0, 0, 0],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
	],
	[ # un chunk 
		# options {biome, speed}
		[1, 0.45],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 2],
		[0, 1, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 1, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 1, 0, 1],
		[0, 0, 1, 0, 1],
		[0, 0, 0, 0, 1],
	],
	[ # un chunk 
		# options {biome, speed}
		[2, 0.45],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 2],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 1, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 1, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 1, 0, 1],
		[0, 0, 1, 0, 1],
		[0, 0, 0, 0, 1],
	],
	[ # un chunk SPACE
		# options {biome, speed}
		[0, 0.45],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 2],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 1, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 1, 0, 0, 1],
		[0, 0, 0, 0, 1],
		[0, 0, 1, 0, 1],
		[0, 0, 1, 0, 1],
		[0, 0, 0, 0, 1],
	],
]


func load_chunk(index_chunk: int, is_monde_interieur: bool):
	actu_chunk = index_chunk
	var chunk = all_chunk[index_chunk]
	var options_chunk = chunk[0]
	monde_interieur = is_monde_interieur
	
	print("actu_chunk = " + str(actu_chunk))
	
	if $"../Introduction".intro and index_chunk == 2:
		$"../Introduction".intro = false
	
	
			
	if not $"../Introduction".flag_passed_dialogue[1] and \
	index_chunk == 0 and not monde_interieur:
		$"../Introduction".show_dialogue(1)
	if not $"../Introduction".flag_passed_dialogue[2] and \
	index_chunk == 0 and monde_interieur:
		$"../Introduction".show_dialogue(2)
	if not $"../Introduction".flag_passed_dialogue[3] and \
	index_chunk == 1 and not monde_interieur:
		$"../Introduction".show_dialogue(3)
	if not $"../Introduction".flag_passed_dialogue[4] and \
	index_chunk == 1 and monde_interieur:
		$"../Introduction".show_dialogue(4)
		

	emit_signal("musique_charge", options_chunk[0], monde_interieur)
	$"../Rythme".set_wait_time(1)
	
	# options
	if is_monde_interieur:
		# set background
		$"../../ParallaxBackground/Background/Sprite".animation = str(options_chunk[0]) + "_nuit"
	else:
		# set background
		$"../../ParallaxBackground/Background/Sprite".animation = str(options_chunk[0])
	
	# biome ville
	if options_chunk[0] == 1:
		$"../GUI/Feux".afficher()
		$"../GUI/Feux".on_color_change(2)
		$"../../".is_feux_on = true
		$"../../".feux = 2
	else:
		$"../GUI/Feux".cacher()
		$"../../".is_feux_on = false
	
	chunk_position_colone = 1
	# précédant tunnel
	for colone in range(0, $"../Dodo".COLONE_JOUEUR):
		for ligne in range(5):
			remove_item_grille(ligne, colone)
			add_tunnel(ligne, colone)
	
	for colone in range($"../Dodo".COLONE_JOUEUR, NB_COLONE):
		load_colone_chunk(colone)
		
	$"../Dodo".position = $"../Dodo".get_vecteur_position_ligne($"../Dodo".position_ligne)
	$"../Dodo".target_position = $"../Dodo".get_vecteur_position_ligne($"../Dodo".position_ligne)
	
	
func load_colone_chunk(colone: int):
	var biom = all_chunk[actu_chunk][0][0]
	if is_space:
		biom = randi() % 3
	
	if (chunk_position_colone < len(all_chunk[actu_chunk]) - 1):
		var col = all_chunk[actu_chunk][chunk_position_colone]
		chunk_position_colone += 1
		if chunk_position_colone < len(all_chunk[actu_chunk]):
			for ligne in range(5):
				remove_item_grille(ligne, colone)
				match col[ligne]:
					0: # vide
						grille[ligne][colone] = null
					1: # platforme
						add_platforme(ligne, colone, biom)
					2: # platforme
						add_mur(ligne, colone, biom)
					3: # tunnel
						add_tunnel(ligne, colone)
					4: # breakWall
						add_break_wall(ligne, colone)
					5: # wind
						add_wind(ligne, colone)
					6: # fleure
						add_fleure(ligne, colone)
	else:
		# fin chunk
		if not monde_interieur:
			if not is_space:
				# si monde extèrieur : 
				for ligne in range(5):
					remove_item_grille(ligne, colone)
					add_tunnel(ligne, colone)
			else:
				# space
				for ligne in range(5):
					remove_item_grille(ligne, colone)
					var rand = randi() % 100
					if rand < 70:# vide
						grille[ligne][colone] = null
					elif rand < 90: # platforme
						add_platforme(ligne, colone, biom)
					elif rand < 95: # mur
						add_mur(ligne, colone, biom)
					elif rand < 97: # breakWall
						add_break_wall(ligne, colone)
					else: # wind
						add_wind(ligne, colone)
		else:
			# monde intèrieur
			for ligne in range(4):
				remove_item_grille(ligne, colone)
			remove_item_grille(5-1, colone)
			add_platforme(5-1, colone, all_chunk[actu_chunk][0][0])
			
			if not show_halo:
				$"../Halo".position.x = 1500
				$"../Halo".position.y = 300
				$"../Halo".show()
				show_halo = true
				index_deplacement_halo = 0
				
func on_halo():
	$"../Rythme".stop()
	emit_signal("halo")

func _on_Dodo_halo():
	$"../Dodo".is_halo = false
	show_halo = false
	$"../Halo".hide()
	
	if not $"../Introduction".intro:
		load_chunk(actu_chunk, false)
		$"../Dodo".position = $"../Dodo".get_vecteur_position_ligne($"../Dodo".position_ligne)
		$"../Rythme".start()
	else: #en cas de tutoriel
		load_chunk(actu_chunk, false)
		$"../Dodo".position = $"../Dodo".get_vecteur_position_ligne($"../Dodo".position_ligne)
#		$"../Rythme".set_wait_time(1)
		$"../Rythme".start()
