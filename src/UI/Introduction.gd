extends CanvasLayer
signal intro

var intro = false

var anim = 0
var n = true 
var l = 3 #Nombre de lignes à présenter

var sprite = 0 #Sprite accompagnant le texte
var textSpeed = 0
#Tableau où se trouve les dialogues
var dialogue : Array = []

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
	$Panel/PastqText.text = dialogue[1]


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
	if textSpeed < chatLimit:
		textSpeed += 1
		$Panel/PastqText.visible_characters = textSpeed

#S'occupe des sprites de la Pastq
func  sprite_intro():
	match sprite:
		2: #Sprite Normal
			$Pastq/AnimatedSprite.set_frame(0)
		6: #Sprite Blush
			$Pastq/AnimatedSprite.set_frame(1)
		4: #Sprite Cool
			$Pastq/AnimatedSprite.set_frame(2)
			$"../Rythme".set_wait_time(1)
			$"../Rythme".start()
			$"../..".actu_musique = -1
		5: #Sprite Surprised
			$Pastq/AnimatedSprite.set_frame(3)
		3: #Sprite Noice
			$Pastq/AnimatedSprite.set_frame(4)
		1: #Sprite Mad
			$Pastq/AnimatedSprite.set_frame(5)
		
	sprite += 1

func _physics_process(_delta): #Montre les lignes une par une
	
	if Input.is_action_just_pressed("ui_down"):
		emit_signal("intro")
	
	$Panel/PastqText.rect_size = $Panel.rect_size
	
	$Panel/PastqText.set_max_lines_visible(3)
	if Input.is_action_just_pressed("ui_select"):
		sprite_intro()
		$Panel/PastqText.hide()
		$Panel/PastqText.set_lines_skipped(l)
		textSpeed = 0
		$Panel/PastqText.show()
		l += 3
	if l > $Panel/PastqText.get_line_count():
		$Panel.hide()
		$Pastq.hide()
