class_name itemSpeed
extends Area2D

@export var multiplicador_velocidad := 2.0  # Multiplicador de velocidad (el doble)
@export var duracion := 10.0  # Duración en segundos

func _ready():
	hide()  # Ocultar el ítem al inicio del juego
	monitoring = false  # Desactivar colisiones inicialmente

	# Mostrar el ítem después de un tiempo
	await get_tree().create_timer(10.0).timeout
	show()
	monitoring = true  # Habilitar colisiones

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Character":  # Verifica que el nodo que entra es el personaje
		print("Ítem recogido: Velocidad aumentada")

		# Incrementar la velocidad del personaje temporalmente
		if body.has_method("incrementar_velocidad"):  # Verifica que el personaje tenga el método
			body.incrementar_velocidad(multiplicador_velocidad, duracion)

		# Ocultar el ítem después de recogerlo
		hide()
		set_deferred("monitoring", false)  # Desactiva las colisiones
