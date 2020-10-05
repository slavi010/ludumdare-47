extends Path2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var patrol_points 

# Called when the node enters the scene tree for the first time.
func _ready():
	patrol_points = curve.get_baked_points()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
