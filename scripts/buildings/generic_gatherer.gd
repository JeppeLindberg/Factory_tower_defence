extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var resource_path: String

var _root_node
var _gatherer_specific
var _main_scene
var _world_timer
var _resource_container
var _debug

var _next_event_time


func activate():
	_root_node = get_parent()
	_gatherer_specific = get_child(0)
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)
	_debug = get_node(_scene_paths.DEBUG)
	_resource_container = _root_node.get_node("resource_container")

	_next_event_time = _world_timer.seconds() + 1.0 / _gatherer_specific.resources_per_second 

func _process(_delta):
	if _world_timer.seconds() >= _next_event_time:
		var charge_time = _world_timer.seconds() - _next_event_time
		_next_event_time += 1.0 / _gatherer_specific.resources_per_second
		event(charge_time)

# Execute an event, as defined by the gatherer implementation
func event(charge_time):
	var new_resource = _main_scene.create_node(resource_path, _resource_container)
	new_resource.initialize(charge_time)
