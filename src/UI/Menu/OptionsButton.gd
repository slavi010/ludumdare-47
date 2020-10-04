extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_OptionsButton_mouse_entered():
	bbcode_text = "[wave amp=100 freq=3]Options[/wave]"


func _on_OptionsButton_mouse_exited():
	bbcode_text = "Options"
