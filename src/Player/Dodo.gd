extends Area2D

var Platforme = load("res://Map/Obstacle/Platforme.tscn")

signal sp

var TAILLE_ECRANT2 = get_viewport_rect().size
var nbsp = 3 #Le nombre de sp va de 0 à 3

var position_ligne = 4

# la colone du joueur (0 pour tou à cauche)
export var COLONE_JOUEUR = 0

# action :
#  0 = rien
#  1 = up
#  2 = down
#  3 = planer
var pressed_action = 0
 
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = "1walk"
	$AnimatedSprite.animation = "1walk"
	
	
	# connect à chaque beat
	$"../".connect("beat", self, "_on_Main_beat")
	position = $"../Grille".position

func sp_bar(): #Gère la barre de SPc
	if nbsp != 3 :
		emit_signal("sp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_UP: # aller vers le haut
			pressed_action = 1
		if event.pressed and event.scancode == KEY_DOWN: # aller vers le bas
			pressed_action = 2
		if event.pressed and event.scancode == KEY_RIGHT: # planer
			pressed_action = 3

# A chaque resception d'un beat
func _on_Main_beat():
	var actu_col = $"../Grille".get_colone_grille(COLONE_JOUEUR)
	var next_col = $"../Grille".get_colone_grille(COLONE_JOUEUR + 1)

#func jump():
	
	var is_action_done = false
	match pressed_action:
		1:
			if (position_ligne > 0) and \
			is_no_platforme(actu_col[position_ligne - 1]) and \
			is_no_platforme(next_col[position_ligne - 1]):
				move_player(1)
				is_action_done = true
		3: 
			if is_no_platforme(actu_col[position_ligne]):
				move_player(3)
				is_action_done = true
	if not is_action_done:
		move_player(0)
		
	pressed_action = 0
			
#	if Input.is_action_pressed("ui_down"):



func move_player(action: int):
	var actu_col = $"../Grille".get_colone_grille(COLONE_JOUEUR)
	var next_col = $"../Grille".get_colone_grille(COLONE_JOUEUR + 1)
	match action:
		1:
			if len($"../Grille".lignes):
				position_ligne -= 1
				position = get_vecteur_position_ligne(position_ligne)
		0:
			if (position_ligne <  4) and \
			is_no_platforme(actu_col[position_ligne]) and \
			is_no_platforme(next_col[position_ligne]):
				position_ligne += 1
				position = get_vecteur_position_ligne(position_ligne)
			pass
		3:
			pass
func is_no_platforme(obj):
	if obj != null:
		if obj.get_script().get_path().get_file() != "Platforme.gd":
			return true
		return false
	return true

func get_vecteur_position_ligne(ligne: int):
	var actu_ligne = $"../Grille".lignes[position_ligne]
	var largeur_patrole_index = len(actu_ligne.patrol_points)/$"../Grille".NB_COLONE
	# calcule de la position de l'index sur le path
	var patrol_index = largeur_patrole_index * (0.5 + COLONE_JOUEUR)
	# on détermine le prochain point
	var target = actu_ligne.patrol_points[patrol_index]
	if position.distance_to(target) < 1:
		patrol_index = wrapi(patrol_index + 1, 0, actu_ligne.patrol_points.size())
	# on va à la position
	return actu_ligne.patrol_points[patrol_index] + \
		$"../Grille".position + Vector2(0, $"../Grille".HAUTEUR_LIGNE*position_ligne)
