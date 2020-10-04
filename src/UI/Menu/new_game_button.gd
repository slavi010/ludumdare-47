extends RichTextLabel


func _on_NewGameButton_mouse_entered():
	bbcode_text = "[wave amp=100 freq=3]New game[/wave]"


func _on_NewGameButton_mouse_exited():
	bbcode_text = "New game"
