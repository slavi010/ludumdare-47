extends Area2D

var Platforme = load("res://Map/Obstacle/Platforme.tscn")

signal energyChange(nb_energy_left)
signal traversTunnel
signal dodoTombe
signal dodoHalo

var TAILLE_ECRANT2 = get_viewport_rect().size
var MAX_ENERGY = 5
var energy: float = MAX_ENERGY #Le nombre de sp va de 0 à 3

var position_ligne = 4

# la colone du joueur (0 pour tou à cauche)
export var COLONE_JOUEUR = 2

# action :
#  0 = rien
#  1 = up
#  2 = down
#  3 = planer
#  4 = dash
var pressed_action = 0

var target_position: Vector2 = Vector2(0, 0)
export var SPEED_ANIMATION = 2

var nb_input_pressed = 0
var faild_input : bool = false

export var TOMBE_SPEED = 150
export var HALO_SPEED = 200
var is_tombe: bool = false
var is_halo: bool = false
 
# Called when the node enters the scene tree for the first time.
func _ready():
	# connect à chaque beat
	$"../../".connect("beat", self, "_on_Main_beat")
	$TimerChangeAnimation.connect("timeout", self, "_on_TimerChangeAnimation_timeout")
	$TimerMal.connect("timeout", self, "_on_TimerMal_timeout")
	$TimerTombe.connect("timeout", self, "_on_TimerTombe_timeout")
	$"../Grille".connect("halo", self, "_on_Grille_halo")
	$TimerHalo.connect("timeout", self, "_on_TimerHalo_timeout")
	
	position = $"../Grille".position
	scale.x = $"../Grille".HAUTEUR_LIGNE/90.0
	scale.y = $"../Grille".HAUTEUR_LIGNE/90.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	var velocite = target_position - position
	position += velocite*delta*SPEED_ANIMATION/($"../Rythme".wait_time/2)
	
	
	# animation player tombe
	if is_tombe:
		 target_position.y += delta*TOMBE_SPEED
	if is_halo:
		 target_position += Vector2(delta*HALO_SPEED, -delta*HALO_SPEED)
	
	
	
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
		if event.pressed and event.scancode == KEY_LEFT: # dash
			pressed_action = 4
			too_much_input()
			

func too_much_input():
	nb_input_pressed += 1
	if nb_input_pressed > 1:
		faild_input = true

# A chaque resception d'un beat
func _on_Main_beat():
	var actu_col = $"../Grille".get_colone_grille(COLONE_JOUEUR)
	var next_col = $"../Grille".get_colone_grille(COLONE_JOUEUR + 1)
	
	var is_action_done = false
	
	# si le joueur n'a pas spam ses touches
	if not faild_input:
		match pressed_action:
			1:
				if (position_ligne > 0) and energy > 0 and \
				is_no_platforme(actu_col[position_ligne - 1]) and \
				is_no_platforme(next_col[position_ligne - 1]) and \
				is_no_mur(actu_col[position_ligne - 1]) and \
				is_no_mur(next_col[position_ligne - 1]):
					move_player(1)
					is_action_done = true
			3: 
				if energy >= 0.5 and \
				is_no_platforme(actu_col[position_ligne]) and \
				is_no_mur(next_col[position_ligne]):
					move_player(3)
					is_action_done = true
			4:
				if energy >= 1 and \
				is_no_platforme(next_col[position_ligne]) and \
				is_no_mur(next_col[position_ligne]):
					move_player(4)
					is_action_done = true
	if not is_action_done:
		move_player(0)
	
	faild_input = false		
	pressed_action = 0
	nb_input_pressed = 0
	
	next_col = $"../Grille".get_colone_grille(COLONE_JOUEUR + 1)
	if is_tunnel(next_col[position_ligne]):
		emit_signal("traversTunnel")
			
#	if Input.is_action_pressed("ui_down"):



func move_player(action: int):
	var actu_col = $"../Grille".get_colone_grille(COLONE_JOUEUR)
	var next_col = $"../Grille".get_colone_grille(COLONE_JOUEUR + 1)
	match action:
		1:
			if len($"../Grille".lignes):
				position_ligne -= 1
				set_target_position(get_vecteur_position_ligne(position_ligne))
				energy -= 1
				emit_signal("energyChange", energy)
				set_sprite_up(true)
		0:
			if (position_ligne <  4) and \
			is_no_platforme(actu_col[position_ligne]) and \
			is_no_platforme(next_col[position_ligne]) and \
			is_no_mur(actu_col[position_ligne + 1]) and \
			is_no_mur(next_col[position_ligne + 1]):
				position_ligne += 1
				set_target_position(get_vecteur_position_ligne(position_ligne))
				set_sprite_drop(true)
				
				if not is_no_break_wall(next_col[position_ligne]):
					mort()
			else:
				if is_no_mur(next_col[position_ligne]) and \
				is_no_break_wall(next_col[position_ligne]):
					energy = min(MAX_ENERGY, energy + 1)
					emit_signal("energyChange", energy)
					set_sprite_walk(true)
				else:
					mort()
		3:
			energy -= 0.5
			emit_signal("energyChange", energy)
			set_sprite_plane(true)
		4:
			if not(is_no_mur(next_col[position_ligne])):
				mort()
			else:
				if is_no_break_wall(next_col[position_ligne]):
					set_sprite_dash(true)
				else:
					set_sprite_dash(true)

				energy -= 1
				emit_signal("energyChange", energy)


			set_sprite_plane(true)

func mort():
	$"../Rythme".stop()
	$TimerMal.start()
	set_sprite_mal()

func is_no_platforme(obj):
	if obj != null:
		if obj.get_script().get_path().get_file() != "Platforme.gd":
			return true
		return false
	return true
	
func is_no_mur(obj):
	if obj != null:
		if obj.get_script().get_path().get_file() != "Mur.gd":
			return true
		return false
	return true

func is_no_break_wall(obj):
	if obj != null:
		if obj.get_script().get_path().get_file() != "BreakWall.gd":
			return true
		return false
	return true
	
func is_tunnel(obj):
	if obj != null:
		if obj.get_script().get_path().get_file() == "Tunnel.gd":
			return true
	return false

func set_target_position(new_position: Vector2):
	target_position = new_position
	courbure()


func get_vecteur_position_ligne(ligne: int):
	if len($"../Grille".lignes) > 0:
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
	return Vector2(0, 0)

# ajuste la rotation et la target position
func courbure():
	var diff = target_position - $"../Grille".centre_planet
	rotation = -atan(diff.x/diff.y)
	var offset_y = $"../Grille".centre_planet.y - $"../Grille".lignes[position_ligne].position.y - cos(rotation) *($"../Grille".centre_planet.y - $"../Grille".lignes[position_ligne].position.y)	
	
	if $"../Grille".monde_interieur:
		rotation *= -1
		offset_y *= -1
	
	target_position.y += offset_y
	var hyp = $"../Grille".HAUTEUR_LIGNE*4 - $"../Grille".lignes[position_ligne].position.y
	target_position.x += sin(rotation)*hyp




func _on_TimerChangeAnimation_timeout():
	var actu_col = $"../Grille".get_colone_grille(COLONE_JOUEUR)
	if not is_no_platforme(actu_col[position_ligne]):
		set_sprite_walk(false)
	else:
		set_sprite_plane(false)

func _on_TimerMal_timeout():
	$TimerTombe.start()
	set_sprite_drop(false)
	is_tombe = true
	
func _on_Grille_halo():
	$TimerHalo.start()
	set_sprite_up(false)	
	is_halo = true
	
func _on_TimerTombe_timeout():
	emit_signal("dodoTombe")
	
func _on_TimerHalo_timeout():
	print("_on_TimerHalo_timeout")
	emit_signal("dodoHalo")

func set_sprite_up(active_timer: bool):
	change_animation("jump", active_timer)
	
func set_sprite_plane(active_timer: bool):
	change_animation("planer", active_timer)

func set_sprite_dash(active_timer: bool):
	change_animation("planer", active_timer)

func set_sprite_drop(active_timer: bool):
	change_animation("drop", active_timer)
	
func set_sprite_walk(active_timer: bool):
	change_animation("walk", active_timer)

func set_sprite_mal():
	change_animation("mal", false)
	
func change_animation(name_animation, active_timer: bool):
	$AnimatedSprite.animation = name_animation
	if active_timer:
		$TimerChangeAnimation.wait_time = $"../Rythme".wait_time/2
		$TimerChangeAnimation.start()
