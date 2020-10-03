extends Node

signal beat

export var largeur = 5 #nombre de block en largeur
export var decalage = 1 #décalage du joueur 

func _on_Rythme_timeout(): #A chaque beat envoi un signal
	emit_signal("beat")

func new_place():
	 #if (): #Condition correspondant au lieu où se trouve le joueur
		#$Rythme.wait_time(n) Changement du temps entre chaque beat
	#else:
		#Rythme.wait_time(n/2)
	
	
	pass

func sp_charge(): #Signal présent quand sp non rempli
	if emit_signal("beat"): #and vertical_speed == 0
		#sp += 1
		pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
