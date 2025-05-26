extends Node2D

@onready var video_player = $SubViewport/VideoStreamPlayer

func _ready():
	video_player.play()
	video_player.connect("finished", Callable(self, "_on_video_finished"))

func _on_video_finished():
	get_tree().change_scene_to_file("res://Levels/level_prueba.tscn")
