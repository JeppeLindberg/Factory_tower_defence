extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var gathers_per_second: float = 1.0

@export var stone_resource_path: String

var _gatherer_generic
var _main_scene


func _ready():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_gatherer_generic = get_parent()

# Gather resources once
func gather(charge_time):
	var new_resource = _main_scene.create_node(stone_resource_path, _gatherer_generic.resource_container)
	new_resource.initialize(charge_time)
