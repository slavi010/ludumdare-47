extends TextureRect

var feux

func _ready():
	feux = [$Rouge,$Orange,$Vert]
	hide_all()
	feux[1].show()
	cacher()

func hide_all():
	for feu in feux:
		feu.hide()

func on_color_change(color):
	hide_all()
	feux[color].show()

func afficher():
	show()

func cacher():
	hide()
