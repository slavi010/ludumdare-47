extends Node

signal beat

export var largeur = 5 #nombre de block en largeur
export var decalage = 1 #décalage du joueur 

export var PITCH_SCALE_AMPLIFICATION = 1.5

var musiquePlayers: Array = []
var actu_musique: int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	$"All/Rythme".connect("timeout", self, "_on_Rythme_timeout")
	$"All/Grille".connect("musique_charge", self, "_on_Musique_change")
	
	$"All/Grille".load_chunk(0, false)


func _on_Rythme_timeout(): #A chaque beat envoi un signal
	emit_signal("beat")
	$"All/BeatExt".pitch_scale = max(0.4, 0.4*PITCH_SCALE_AMPLIFICATION/$"All/Rythme".wait_time)
	$"All/BeatExt".play()
	
	# init musique players
	musiquePlayers = [
		[$All/ForetExt, 0.3846],
		[$All/ForetInt, 0.5263],
		[$All/VilleExt, 0.3590],
		[$All/VilleInt, 0.4560],
		[$All/OceanExt, 0.35],
		[$All/OceanInt, 0.35],
	]

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

var scroll_x = 0

func _process(delta):	
	# Scroll background
	if $All/BeatExt.playing:
		scroll_x -= 50 * delta
		$ParallaxBackground.scroll_offset.x = scroll_x
		
	if len(musiquePlayers) > 0 and actu_musique >= 0 \
		and actu_musique < len(musiquePlayers) \
		and  not musiquePlayers[actu_musique][0].playing:
		musiquePlayers[actu_musique][0].play()
		$All/Rythme.wait_time = musiquePlayers[actu_musique][1]
		
		

func _on_Musique_change(biome: int, is_monde_interieur: bool):
	var index_musique = biome*2
	if is_monde_interieur:
		index_musique += 1
	
	if actu_musique != index_musique:
		if actu_musique >= 0 and actu_musique < len(musiquePlayers):
			musiquePlayers[actu_musique][0].stop()
		actu_musique = index_musique

func _on_Introduction_intro():
	$All/Rythme.stop()
