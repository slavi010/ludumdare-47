extends RichTextLabel


var is_mouse_in : bool = false

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and is_mouse_in:
		$"../../Crédits".show()

func _on_CreditButton_mouse_entered():
	is_mouse_in = true


func _on_CreditButton_mouse_exited():
	is_mouse_in = false
