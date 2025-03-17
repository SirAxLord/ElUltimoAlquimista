class_name Bottle
extends Area2D

func _ready():
	# Ocultar el ítem al inicio del juego
	hide()
	monitoring = false  # Desactivar colisiones inicialmente

	# Esperar 10 segundos antes de mostrar el ítem
	await get_tree().create_timer(10.0).timeout
	show()
	monitoring = true  # Habilitar la detección de colisiones

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Character":  # Verifica que el nodo que entra es el personaje
		print("Ítem recogido")

		# Ocultar el ítem después de recogerlo
		hide()
		set_deferred("monitoring", false)  # Desactiva las colisiones de manera segura
