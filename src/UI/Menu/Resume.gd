extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var is_mouse_in : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and is_mouse_in:
		$"../".hide()
		is_mouse_in = false


func _on_Resume_mouse_entered():
	is_mouse_in = true


func _on_Resume_mouse_exited():
	print("ouais")
	is_mouse_in = false
