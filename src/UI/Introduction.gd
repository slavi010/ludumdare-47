extends CanvasLayer

var anim = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	var _v = $PastqText.get_line_count()
	$PastqText.show() #Lors de l'apparition du texte, faire une animation
	$PastqText/Box.start()

func show_message(text):
	$PastqText.text = text
	$PastqText.show()


func anim_text():
	if true :
		if anim == 0:
			$PastqText.rect_position.y -= 10
			anim=1
		else:
			$PastqText.rect_position.y += 10
			anim=0
	else:
		$PastqText/Box.stop()
	
	
	#$PastqText.max_lines_visible(1) #Montre les lignes lorsque 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
