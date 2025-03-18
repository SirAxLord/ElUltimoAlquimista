class_name CactusTrap
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Character":  # Verifica que el nodo que entra es el personaje
		print("Daño al jugador por trampa")

		# Regresar al jugador a la coordenada (0, 0)
		if body.has_method("set_global_position"):
			body.global_position = Vector2(50, 0)
