extends Control

func _on_reiniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level_prueba.tscn")


func _on_salir_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/Menus/Menu_Principal.tscn")
