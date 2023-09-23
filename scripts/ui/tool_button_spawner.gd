extends HBoxContainer

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var remove_button_path: String

var _main_scene


func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)

	_main_scene.create_node(remove_button_path, self)
