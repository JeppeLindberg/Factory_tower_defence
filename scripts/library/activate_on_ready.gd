extends Node

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

func _ready():
	var main_scene = get_node(_scene_paths.MAIN_SCENE)
	main_scene.activate_node(self)


