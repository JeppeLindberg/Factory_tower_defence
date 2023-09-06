extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var root_node
var resource_container
var _gatherer_specific
var _main_scene
var _world_timer
var _debug

var _next_event_time


func activate():
	root_node = get_parent()
	_gatherer_specific = get_child(0)
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_world_timer = get_node(_scene_paths.WORLD_TIMER)
	_debug = get_node(_scene_paths.DEBUG)
	resource_container = root_node.get_node("resource_container")

	_next_event_time = _world_timer.seconds() + 1.0 / _gatherer_specific.gathers_per_second 

func _process(_delta):
	if _world_timer.seconds() >= _next_event_time:
		var charge_time = _world_timer.seconds() - _next_event_time
		_next_event_time += 1.0 / _gatherer_specific.gathers_per_second
		gather(charge_time)

# Execute an gather, as defined by the gatherer implementation
func gather(charge_time):
	_gatherer_specific.gather(charge_time)

