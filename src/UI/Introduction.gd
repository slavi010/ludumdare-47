extends CanvasLayer

var anim = 0
var n = true 
var l = 1 #Nombre de lignes à présenter

# Called when the node enters the scene tree for the first time.
func _ready():
	var _v = $PastqText.get_line_count()
	$PastqText.show() #Lors de l'apparition du texte, faire une animation
	$PastqText/Box.start()

func show_message(text):
	$PastqText.text = text
	$PastqText.show()

func text_box_melon(): #Fond PASTEQUE
	$PastqText/textboxmelon.transform_position.x = $PastqText.rect_position.x
	$PastqText/textboxmelon.transform_position.y = $PastqText.rect_position.y

func anim_text():
	if n :
		if anim == 0:
			$PastqText.rect_position.y -= 10
			anim=1
		else:
			$PastqText.rect_position.y += 10
			anim=0
	else:
		$PastqText/Box.stop()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta): #Montre les lignes une par une
	$PastqText.set_max_lines_visible(l)
	if Input.is_action_just_pressed("ui_select"):
		l += 1
