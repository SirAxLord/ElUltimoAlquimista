extends Area2D

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		get_tree().change_scene_to_file("res://Escenas/Menus/menu_fin.tscn")
