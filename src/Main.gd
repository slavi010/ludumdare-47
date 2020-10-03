extends Node

signal beat

func _on_Rythme_timeout(): #A chaque beat envoi un signal
	emit_signal("beat")



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
