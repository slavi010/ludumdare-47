extends Area2D

signal sp



var nbsp = clamp(nbsp, 0, 3) #Le nombre de sp va de 0 à 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func sp_bar(): #Gère la barre de SP
	if nbsp != 3 :
		emit_signal("sp")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2() #Mouvement du joueur en 2D 
	
	#var gravity = -10 
	#velocity.y += gravity*delta
	
	if Input.is_action_pressed("ui_select"):
		velocity.y -= 1
	if velocity.y < 0: #Lors d'un saut, on passe au sprite "jump"
		$AnimatedSprite.animation = "jump"
	if velocity.y > 0: #Lors d'une déscente, on passe au sprite "drop"
		$AnimatedSprite.animation = "drop"
	
	
