extends Area2D

var Platforme = load("res://Map/Obstacle/Platforme.tscn")

signal energyChange(nb_energy_left)

var TAILLE_ECRANT2 = get_viewport_rect().size
var MAX_ENERGY = 5
var energy: int = MAX_ENERGY #Le nombre de sp va de 0 à 3

var position_ligne = 4

# la colone du joueur (0 pour tou à cauche)
export var COLONE_JOUEUR = 2

# action :
#  0 = rien
#  1 = up
#  2 = down
#  3 = planer
var pressed_action = 0

var target_position: Vector2 = Vector2(0, 0)
export var SPEED_ANIMATION = 2

var nb_input_pressed = 0
var faild_input : bool = false
 
# Called when the node enters the scene tree for the first time.
func _ready():
	# connect à chaque beat
	$"../".connect("beat", self, "_on_Main_beat")
	$TimerChangeAnimation.connect("timeout", self, "_on_TimerChangeAnimation_timeout")
	position = $"../Grille".position
	scale.x = $"../Grille".HAUTEUR_LIGNE/90.0
	scale.y = $"../Grille".HAUTEUR_LIGNE/90.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	var velocite = target_position - position
	position += velocite*delta*SPEED_ANIMATION/($"../Rythme".wait_time/2)
	
	
func _unhandled_input(event):
	
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_UP: # aller vers le haut
			pressed_action = 1
			too_much_input()
		if event.pressed and event.scancode == KEY_DOWN: # aller vers le bas
			pressed_action = 2
			too_much_input()
		if event.pressed and event.scancode == KEY_RIGHT: # planer
			pressed_action = 3
			too_much_input()
			

func too_much_input():
	nb_input_pressed += 1
	print(pressed_action)
	if nb_input_pressed > 1:
		faild_input = true

# A chaque resception d'un beat
func _on_Main_beat():
	var actu_col = $"../Grille".get_colone_grille(COLONE_JOUEUR)
	var next_col = $"../Grille".get_colone_grille(COLONE_JOUEUR + 1)

#func jump():
	
	var is_action_done = false
	
	# si le joueur n'a pas spam ses touches
	if not faild_input:
		match pressed_action:
			1:
				if (position_ligne > 0) and energy > 0 and \
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
	
	faild_input = false		
	pressed_action = 0
	nb_input_pressed = 0
			
#	if Input.is_action_pressed("ui_down"):



func move_player(action: int):
	var actu_col = $"../Grille".get_colone_grille(COLONE_JOUEUR)
	var next_col = $"../Grille".get_colone_grille(COLONE_JOUEUR + 1)
	match action:
		1:
			if len($"../Grille".lignes):
				position_ligne -= 1
				target_position = get_vecteur_position_ligne(position_ligne)
				energy -= 1
				emit_signal("energyChange", energy)
				set_sprite_up(true)
		0:
			if (position_ligne <  4) and \
			is_no_platforme(actu_col[position_ligne]) and \
			is_no_platforme(next_col[position_ligne]):
				position_ligne += 1
				target_position = get_vecteur_position_ligne(position_ligne)
				set_sprite_drop(true)
			else:
				energy = min(MAX_ENERGY, energy + 1)
				emit_signal("energyChange", energy)
				set_sprite_walk(true)
		3:
			set_sprite_plane(true)
			


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

func _on_TimerChangeAnimation_timeout():
	var actu_col = $"../Grille".get_colone_grille(COLONE_JOUEUR)
	if not is_no_platforme(actu_col[position_ligne]):
		set_sprite_walk(false)
	else:
		set_sprite_plane(false)


func set_sprite_up(active_timer: bool):
	change_animation("jump", active_timer)
	
func set_sprite_plane(active_timer: bool):
	change_animation("planer", active_timer)

func set_sprite_drop(active_timer: bool):
	change_animation("drop", active_timer)
	print("drop")

func set_sprite_walk(active_timer: bool):
	change_animation("walk", active_timer)
	
func change_animation(name_animation, active_timer: bool):
	$AnimatedSprite.animation = name_animation
	if active_timer:
		$TimerChangeAnimation.wait_time = $"../Rythme".wait_time/2
		$TimerChangeAnimation.start()
