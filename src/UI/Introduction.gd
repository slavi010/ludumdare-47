extends CanvasLayer

var anim = 0
var n = true 
var l = 3 #Nombre de lignes à présenter

var textSpeed = 0
#Tableau où se trouve les dialogues
var dialogue : Array = []
var line = ""

#Ouverture d'un fichier
func load_text(file):
	var f = File.new()
	f.open(file, File.READ)
	while not f.eof_reached():
		line = f.get_line()
		line += "\n"
		print(line)
	f.close()
	return line
	#dialogue.append(line)


func turoriel():
	load_text("//res:intro1")
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	var _v = $Panel/PastqText.get_line_count()
	$Panel/Box.start()

func show_message(text):
	$Panel/PastqText.text = text
	$Panel/PastqText.show()


func anim_text():
	if n :
		if anim == 0:
			$Panel.rect_position.y -= 10
			anim=1
		else:
			$Panel.rect_position.y += 10
			anim=0
	else:
		$Box.stop()

#Montre petit à petit le dialogue
func montre_dialogue():
	var chatLimit = $Panel/PastqText.get_total_character_count()
	if textSpeed < chatLimit:
		textSpeed += 1
		$Panel/PastqText.visible_characters = textSpeed

func _physics_process(_delta): #Montre les lignes une par une
	$Panel/PastqText.set_max_lines_visible(3)
	if Input.is_action_just_pressed("ui_select"):
		$Panel/PastqText.hide()
		$Panel/PastqText.set_lines_skipped(l)
		textSpeed = 0
		$Panel/PastqText.show()
		l += 3
	if l > $Panel/PastqText.get_line_count():
		$Panel.hide()
		$Pastq.hide()
