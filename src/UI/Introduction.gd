extends CanvasLayer
signal intro
signal fin_premier_dialogue

var intro = true

var x = 1

var anim = 0
var n = true 
var l = 3 #Nombre de lignes à présenter

var sprite = 0 #Sprite accompagnant le texte
var textSpeed = 0
#Tableau où se trouve les dialogues
var dialogue: Array = []
var dialogue_index: int = -1
var dialogue_sprite = [
	[0], #0
	[0, 0, 0, 5, 0, 1, 4], #
	[3], #2
	[1], #3
	[3], #4
	[4], #5
	[0], #6
	[3,0,2], #7
	[2], #8
	[4], #9
	[6], #10
	[6,0], #11
	[6], #12
	[2], #13
	[0], #14
	[1], #15
	[3], #16
	[0], #17
	[0,7], #18
]

var flag_passed_dialogue: Array = []

#Ouverture d'un fichier
func load_text(file):
	var f = File.new()
	var line = ""
	var lines = ""
	f.open(file, File.READ)
	while not f.eof_reached():
		line = f.get_line()
		lines += line + "\n"
	dialogue.append(lines)
	f.close()

func show_message(text):
	$Panel/PastqText.text = text
	$Panel/PastqText.show()

#On parcours le dossier pour connaître le nb de fichiers
func dir_number():
	var d: int = 0
	var dir = Directory.new()
	dir.open("res://Narration")
	dir.list_dir_begin(true)
	while true:
		if  "" == dir.get_next():
			break
		else:
			d += 1
	dir.list_dir_end()
	return d

#insérer tout les textes dans le tableau Dialogue
func remplir_dialogue():
	var d: int = dir_number()
	for i in range(d):
		var text = "res://Narration/intro" + str(i) + ".txt" 
		load_text(text)

# Called when the node enters the scene tree for the first time.
func _ready():
	remplir_dialogue()
	var _v = $Panel/PastqText.get_line_count()
	$Panel/Box.start()
	
	for i in range(len(dialogue)):
		flag_passed_dialogue.append(false)

func anim_text():
	if n :
		if anim == 0:
			$Panel.rect_position.y -= 10
			anim=1
		else:
			$Panel.rect_position.y += 10
			anim=0
	else:
		$Panel/Box.stop()

#Montre petit à petit le dialogue
func montre_dialogue():
	var chatLimit = $Panel/PastqText.get_total_character_count()
	$Panel/PastqText.set_max_lines_visible(3)
	if textSpeed < chatLimit:
		textSpeed += 1
		$Panel/PastqText.visible_characters = textSpeed

#S'occupe des sprites de la Pastq
func sprite_intro():
#	match sprite:
#		2: #Sprite Normal
#			$Pastq/AnimatedSprite.set_frame(0)
#		6: #Sprite Blush
#			$Pastq/AnimatedSprite.set_frame(1)
#		4: #Sprite Cool
#			$Pastq/AnimatedSprite.set_frame(2)
#			$"../Rythme".set_wait_time(1)
#			$"../Rythme".start()
#			$"../..".actu_musique = -1
#		5: #Sprite Surprised
#			$Pastq/AnimatedSprite.set_frame(3)
#		3: #Sprite Noice
#			$Pastq/AnimatedSprite.set_frame(4)
#		1: #Sprite Mad
#			$Pastq/AnimatedSprite.set_frame(5)
	if sprite < len(dialogue_sprite[dialogue_index]):
		$Pastq/AnimatedSprite.set_frame(dialogue_sprite[dialogue_index][sprite])		
		sprite += 1

func _physics_process(_delta): #Montre les lignes une par une
	$Panel/PastqText.rect_size = $Panel.rect_size
	
	if Input.is_action_just_pressed("ui_select"):
		if l >= $Panel/PastqText.get_line_count() - 3 - x:
			x = 0
			$Panel.hide()
			$Pastq.hide()
			if dialogue_index > 0:
				$"../Rythme".start()
#				$"../..".actu_musique = -1
				
			# fin premier dialogue -> affichage menu
			if dialogue_index == 0:
				emit_signal("fin_premier_dialogue")
			
			dialogue_index = -1
		else:
			$Panel.show()
			$Pastq.show()
			sprite_intro()
			$Panel/PastqText.hide()
			$Panel/PastqText.set_lines_skipped(l)
			textSpeed = 0
			$Panel/PastqText.show()
			l += 3
	
	

func show_dialogue(index: int):
	$Panel/PastqText.text = dialogue[index]
	emit_signal("intro")
	flag_passed_dialogue[index] = true
	dialogue_index = index
	l = 0
	sprite = 0
	$Panel.show()
	$Pastq.show()
	sprite_intro()
	$Panel/PastqText.show()
	$Panel/PastqText.set_lines_skipped(l)
	



