extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _root_node
var _main_scene
var _terrain
var _paths
var _debug
var _resource_container


func activate():
	_root_node = get_parent()
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_paths = _terrain.get_node("paths")
	_debug = get_node(_scene_paths.DEBUG)
	_resource_container = _root_node.get_node("resource_container")

	_resource_container.resource_capacity = 0

# Get the facing of the splitter as a vector
func facing():
	var vec = Vector2.UP.rotated(deg_to_rad(_root_node.get_building_rotation()))
	return Vector2i(vec)


