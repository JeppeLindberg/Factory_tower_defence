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

	var up = Vector2.UP.rotated(deg_to_rad(_root_node.get_building_rotation()))
	var down = Vector2.DOWN.rotated(deg_to_rad(_root_node.get_building_rotation()))

	print(up)

	var prev_coord = _main_scene.pos_to_cell_coord(global_position) + Vector2i(up)
	var this_coord = _main_scene.pos_to_cell_coord(global_position)
	var next_coord = _main_scene.pos_to_cell_coord(global_position) + Vector2i(down)

	_paths.create_conveyor(this_coord, self)
	_paths.connect_coords(prev_coord, this_coord)
	_paths.connect_coords(this_coord, next_coord)


