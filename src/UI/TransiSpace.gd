extends Control


func join_space():
	$Avant.show()
	$Text.show()
	$Transi.start()
	

func _on_Transi_timeout():
	$Avant.hide()
	$Text.hide()
	$Apres.show()
	$RetourJeu.start()


func _on_RetourJeu_timeout():
	hide()
