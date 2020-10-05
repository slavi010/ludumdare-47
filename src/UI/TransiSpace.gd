extends Control

#func _ready():
#	join_space()

func join_space():
	$Avant.show()
	$Text.show()
	show()
	$Transi.start()
	

func _on_Transi_timeout():
	$Avant.hide()
	$Text.hide()
	hide()
	$Apres.show()
	$RetourJeu.start()


func _on_RetourJeu_timeout():
	hide()
