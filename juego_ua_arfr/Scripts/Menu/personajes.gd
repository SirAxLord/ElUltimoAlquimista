extends Control

func _on_one_player_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level_prueba.tscn")

func _on_two_players_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level_prueba.tscn")

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Escenas/menu.tscn")
