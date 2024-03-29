extends RichTextLabel

var is_mouse_in : bool = false

signal start_game

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and is_mouse_in:
		emit_signal("start_game")

func _on_NewGameButton_mouse_entered():
	bbcode_text = "[wave amp=100 freq=3]New game[/wave]"
	is_mouse_in = true


func _on_NewGameButton_mouse_exited():
	bbcode_text = "New game"
	is_mouse_in = false
