extends RichTextLabel

var is_mouse_in : bool = false

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and is_mouse_in:
		$"../../Options".show()

func _on_OptionsButton_mouse_entered():
	bbcode_text = "[wave amp=100 freq=3]Options[/wave]"
	is_mouse_in = true


func _on_OptionsButton_mouse_exited():
	bbcode_text = "Options"
	is_mouse_in = false
