class_name itemFuerza
extends Area2D

@export var aumento_fuerza := 10  # Incremento de fuerza
@export var duracion := 5.0  # Duración en segundos

func _ready():
	hide()  # Ocultar el ítem al inicio del juego
	monitoring = false  # Desactivar colisiones inicialmente

	# Mostrar el ítem después de 10 segundos
	await get_tree().create_timer(10.0).timeout
	show()
	monitoring = true  # Habilitar colisiones

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Character":  # Verifica que el nodo que entra es el personaje
		print("Ítem recogido: Fuerza aumentada")

		# Incrementa la fuerza del personaje temporalmente
		if body.has_method("incrementar_fuerza"):  # Verifica que el personaje tenga el método
			body.incrementar_fuerza(aumento_fuerza, duracion)

		# Ocultar el ítem después de recogerlo
		hide()
		set_deferred("monitoring", false)  # Desactiva las colisiones
