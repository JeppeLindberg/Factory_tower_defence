extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

var _root_node
var _main_scene
var _terrain
var _paths
var _debug

var path = null


func activate():
	_root_node = get_parent()
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_paths = _terrain.get_node("paths")
	_debug = get_node(_scene_paths.DEBUG)

	var path_connections = _get_path_connections()

	_paths.create_conveyor(path_connections[1], self)
	_paths.connect_conveyors(path_connections[0], path_connections[1])
	_paths.connect_conveyors(path_connections[1], path_connections[2])

	_paths.autoconnect_all()

func _get_path_connections():
	var up = Vector2.UP.rotated(deg_to_rad(_root_node.get_building_rotation()))
	var down = Vector2.DOWN.rotated(deg_to_rad(_root_node.get_building_rotation()))

	var prev_coord = _main_scene.pos_to_coord(global_position) + Vector2i(up)
	var this_coord = _main_scene.pos_to_coord(global_position)
	var next_coord = _main_scene.pos_to_coord(global_position) + Vector2i(down)

	return [prev_coord, this_coord, next_coord]

# Get the facing of the conveyor belt as a vector
func facing():
	var vec = Vector2.UP.rotated(deg_to_rad(_root_node.get_building_rotation()))
	return Vector2i(vec)

# Remove the connections in path
func destroy():
	var path_connections = _get_path_connections()
	# TODO: Remove from paths


