class_name CactusTrap
extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Character":  # Verifica que el nodo que entra es el personaje
		print("Daño al jugador por trampa")

		# Resta 10 puntos de vida al personaje
		if body.has_method("recibir_dano"):
			body.recibir_dano(5)  # Aplica 5 de daño
