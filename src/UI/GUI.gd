extends MarginContainer

export var nb_pasteque_total = 5
var nb_pasteque_current = nb_pasteque_total
var texture_pasteque = preload("res://UI/Assets/energy.png")

var time = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	#Instanciation du nombre d'energie par défaut
	for i in range(nb_pasteque_total):
		add_pasteque()
		
	$"../Dodo".connect("energyChange", self, "on_energy_change")

#Création et ajout de la node energie dans l'arborescence
func add_pasteque():
	var energy = TextureRect.new()
	energy.expand = true
	energy.texture = texture_pasteque
	energy.rect_min_size = Vector2(43,64)
	$"HBoxContainer/Energy".add_child(energy)
	

#Function a executer au moment de la récéption du signal de changement d'énergie
#Cache ou révèle les énergies en fonction du nouveau nombre d'énergie que le joueur
#possède et du nombre d'énergie qu'il possédait déjà
func on_energy_change(energy):
	if nb_pasteque_current > energy :
		#Cache les dernières pastèques (récupérées par .get_children())
		#Par de la dernière pastèques cachée jusqu'à celle correspondant au nombre
		#de pastèques actuel
		for i in range(nb_pasteque_total - nb_pasteque_current, nb_pasteque_total - energy):
			$"HBoxContainer/Energy".get_children()[-(i+1)].hide()
		nb_pasteque_current = energy
	elif nb_pasteque_current < energy:
		for i in range(nb_pasteque_current, energy):
			$"HBoxContainer/Energy".get_children()[i].show()
		nb_pasteque_current = energy
