extends Node

signal beat

export var largeur = 5 #nombre de block en largeur
export var decalage = 1 #décalage du joueur 

export var PITCH_SCALE_AMPLIFICATION = 1.5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Rythme.connect("timeout", self, "_on_Rythme_timeout")
	
	$Grille.load_chunk(0, false)


func _on_Rythme_timeout(): #A chaque beat envoi un signal
	emit_signal("beat")
	$BeatExt.pitch_scale = max(0.4, 0.4*PITCH_SCALE_AMPLIFICATION/$Rythme.wait_time)
	$BeatExt.play()

func new_place():
	 #if (): #Condition correspondant au lieu où se trouve le joueur
		#$Rythme.wait_time(n) Changement du temps entre chaque beat
	#else:
		#Rythme.wait_time(n/2)
	
	
	pass

func sp_charge(): #Signal présent quand sp non rempli
	if emit_signal("beat"): #and vertical_speed == 0
		#nbsp += 1
		pass




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
