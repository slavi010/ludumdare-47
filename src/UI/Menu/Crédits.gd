extends TextureRect

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() :
		hide()
