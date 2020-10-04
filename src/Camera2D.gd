extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../".connect("beat", self, "_on_Main_beat")


func _on_Main_beat():
	offset.x += $"../All/Grille".TAILLE_ECRANT.x/$"../All/Grille".NB_COLONE

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
