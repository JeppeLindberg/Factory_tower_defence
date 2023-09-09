extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var speed: float
@export var max_health: float

var enemy_generic

var _main_scene

func activate():
	enemy_generic = get_parent()
	_main_scene = get_node(_scene_paths.MAIN_SCENE)

	enemy_generic.health = max_health
