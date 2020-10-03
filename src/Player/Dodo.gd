extends Area2D

signal sp

var grav = 400
var TAILLE_ECRANT2 = get_viewport_rect().size
var speed_player = 400
var nbsp = 3 #Le nombre de sp va de 0 à 3

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.animation = "1walk"
	pass # Replace with function body.

func sp_bar(): #Gère la barre de SP
	if nbsp != 3 :
		emit_signal("sp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO #Mouvement du joueur en 2D 
	
	velocity.y = grav
	velocity = velocity * speed_player
	if Input.is_action_pressed("ui_select"):
		velocity.y -= 100
	if Input.is_action_pressed("ui_right"):
		velocity.x += 100
	#if velocity.y < 0: #Lors d'un saut, on passe au sprite "jump"
		#$AnimatedSprite.animation = "jump"
	#if velocity.y > 0: #Lors d'une déscente, on passe au sprite "drop"
		#$AnimatedSprite.animation = "drop"
	position += velocity*delta
	position.x = clamp(position.x, 0, TAILLE_ECRANT2.x) #Limitation du déplacement sur l'écran
	position.y = clamp(position.y, 0, TAILLE_ECRANT2.y)
	
