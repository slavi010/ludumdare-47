extends Control

#func _ready():
#	join_space()

var break_world = false

func join_space():
	$Avant.show()
	$Text.show()
	show()
	break_world = true

func _on_RetourJeu_timeout():
	hide()

func _physics_process(delta):
	if break_world:
		if Input.is_action_just_pressed("ui_accept"):
			$Avant.hide()
			$Text.hide()
			hide()
			$Apres.show()
			$RetourJeu.start()
			$"../".launch_space()
			break_world = true
