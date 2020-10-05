extends Node

signal beat
signal feuxChange(couleur)

export var largeur = 5 #nombre de block en largeur
export var decalage = 1 #décalage du joueur 

export var PITCH_SCALE_AMPLIFICATION = 1.5

var musiquePlayers: Array = []
var actu_musique: int = -1

var feux = 2
var is_feux_on: bool = false
var play_back_position: float

# Called when the node enters the scene tree for the first time.
func _ready():
	$"All/Rythme".connect("timeout", self, "_on_Rythme_timeout")
	$"All/Grille".connect("musique_charge", self, "_on_Musique_change")
	$"All/Introduction".connect("fin_premier_dialogue", self, "_on_Introduction_fin_premier_dialogue")
	$TimerFeuxRouge.connect("timeout", self, "_on_TimerFeuxRouge_timeout")
	$All/Dodo.connect("FLEURE", self, "_on_Dodo_fleure")
	$All/Grille.connect("FIN", self, "_on_Grille_fin")
	
	# ICCCCCCCCCCCCCCCCIIIIIIIIIIIIIIIIIIIIIIIIIII
#	$world/AnimationPlayer.play("break")
	$"All/Introduction".show_dialogue(0)
	
	$"All/TextureRect/Control/NewGameButton".connect("start_game", self, "_on_Menu_start_game")
	$"All/TextureRect/Control/".hide()
	$"All/GUI/".hide()
	$"All/Dodo/".hide()
	$"All/Rythme".stop()
	
	

func _on_Menu_start_game():
	$"All/Grille".load_chunk(0, false)
	$"All/TextureRect/Control".hide()
	$"All/TextureRect/Options".hide()
	$"All/GUI/".show()
	$"All/Dodo/".show()
	$"All/Grille/".show()
	$"All/Introduction".show_dialogue(1)
	$"All/TextureRect/AudioStreamPlayer".stop()

func _on_Rythme_timeout(): #A chaque beat envoi un signal
	emit_signal("beat")
	$"All/BeatExt".pitch_scale = max(0.4, 0.4*PITCH_SCALE_AMPLIFICATION/$"All/Rythme".wait_time)
	$"All/BeatExt".play()
	print("actu_musique = " +str(actu_musique))
	
	# init musique players
	musiquePlayers = [
		[$All/ForetExt, 0.3846],
		[$All/ForetInt, 0.5263],
		[$All/VilleExt, 0.3590],
		[$All/VilleInt, 0.4560],
		[$All/OceanExt, 0.3921],
		[$All/OceanInt, 0.5263],
	]
	
	
	if is_feux_on:
		match feux:
			1:
				feux = 0
				$All/Rythme.stop()
				emit_signal("feuxChange", 0)
				play_back_position = musiquePlayers[actu_musique][0].get_playback_position()
				musiquePlayers[actu_musique][0].stop()
			2:
				if (randi() % 30) == 1:
					feux = 1
					emit_signal("feuxChange", 1)
					$TimerFeuxRouge.start()

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
	if $All/BeatExt.playing and not $All/Grille.is_space:
		scroll_x -= 50 * delta
		$ParallaxBackground.scroll_offset.x = scroll_x
		
	if len(musiquePlayers) > 0 and actu_musique >= 0 \
		and actu_musique < len(musiquePlayers) \
		and  not musiquePlayers[actu_musique][0].playing and (not(is_feux_on) or not(feux == 0)):
		musiquePlayers[actu_musique][0].play()
		$All/Rythme.wait_time = musiquePlayers[actu_musique][1]
		
		

func _on_Musique_change(biome: int, is_monde_interieur: bool):
	if $All/Introduction.intro:
		pass
	else:
		var index_musique = biome*2
		if is_monde_interieur:
			index_musique += 1
		
		if actu_musique != index_musique:
			if actu_musique >= 0 and actu_musique < len(musiquePlayers):
				musiquePlayers[actu_musique][0].stop()
			actu_musique = index_musique

func _on_Introduction_intro():
	$All/Rythme.stop()
	if actu_musique >= 0 and len(musiquePlayers) > 0:
		musiquePlayers[actu_musique][0].stop()
		actu_musique = -1
		
func _on_Introduction_fin_premier_dialogue():
	$"All/TextureRect/Control/".show()
	$"All/TextureRect/AudioStreamPlayer".play()


func _on_TimerFeuxRouge_timeout():
	$All/Rythme.start()
#	emit_signal("feuxChange", 2)
	feux = 2
	musiquePlayers[actu_musique][0].play(play_back_position)

func _on_Dodo_fleure():
	print("FLEEEEEEEEEEEEEEEEEEUUUUUUUUUUUUUUUUUUUUUUUUUUUURRRRRRRRRRRRRRRRRRRRRRRR")
	$"All/GUI/".hide()
	$"All/Dodo/".hide()
	$"All/Grille/".hide()
	$TransiSpace.join_space()
	
func launch_space():
	$"All/GUI/".show()
	$"All/Dodo/".show()
	$"All/Grille/".show()
	$All/Grille.load_chunk(len($All/Grille.all_chunk) - 1, false)
	$All/Grille.is_space = true
	$All/Rythme.wait_time = 0.40
	$All/Rythme.start()
	$ParallaxBackground/Background/Sprite.animation = "space"

func _on_Grille_fin():
	$"All/TextureRect/Control/".show()
	$"All/GUI/".hide()
	$"All/Dodo/".hide()
	$"All/Rythme".stop()
	
	$"All/Grille".actu_chunk = -1
	$"All/Grille".is_space = false
