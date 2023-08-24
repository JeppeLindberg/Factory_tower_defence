extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _main_scene
var _generic_building

var building_name
var footprint

func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_generic_building = get_node("generic_building")

func initialize(global_pos):
	global_position = global_pos
	_main_scene.activate_node(self)


