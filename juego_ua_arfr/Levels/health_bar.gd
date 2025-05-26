extends ProgressBar

var character  # Referencia al personaje

func _ready():
	character = get_tree().get_root().get_node("Escenas/Characters/Character.tscn")  # Ajusta esta ruta si es diferente
	if character != null:
		max_value = character.vida
		value = character.vida

func _process(delta):
	if character != null:
		value = character.vida
