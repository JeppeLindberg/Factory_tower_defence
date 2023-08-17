extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()


var _main_scene
var _terrain
var _paths
var _debug

var path = null

func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_paths = _terrain.get_node("paths")
	_debug = get_node(_scene_paths.DEBUG)

	var prev_coord = _main_scene.pos_to_cell_coord(global_position) + Vector2i.UP
	var this_coord = _main_scene.pos_to_cell_coord(global_position)
	var next_coord = _main_scene.pos_to_cell_coord(global_position) + Vector2i.DOWN

	connect_coords(prev_coord, this_coord)
	connect_coords(this_coord, next_coord)


# Connect the conveyor's path with new coordinates in the world
func connect_coords(from_coord, to_coord):
	_paths.connect_coords(from_coord, to_coord)


