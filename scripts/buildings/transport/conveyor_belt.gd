extends Node2D

var _scene_paths := preload("res://scripts/library/scene_paths.gd").new()

@export var new_path_path: String

var _main_scene
var _terrain
var _paths
var _debug

var _path = null

func activate():
	_main_scene = get_node(_scene_paths.MAIN_SCENE)
	_terrain = get_node(_scene_paths.TERRAIN)
	_paths = _terrain.get_node("paths")
	_debug = get_node(_scene_paths.DEBUG)

	var this_coord = _main_scene.pos_to_cell_coord(global_position)

	update_path(this_coord)

func _process(_delta):
	for i in range(_path.curve.point_count - 1):
		_debug.add_draw_line(_path.curve.get_point_position(i), _path.curve.get_point_position(i+1), Color.AQUA)

func update_path(coord):
	var prev_coord = _main_scene.pos_to_cell_coord(global_position) + Vector2i.UP

	var prev_cell_info = _terrain.get_cell(prev_coord)

	if prev_cell_info["building"] == null:
		_start_new_path(prev_coord, coord)
		return

	if prev_cell_info["building"].building_name == "conveyor_belt":
		prev_cell_info["building"].get_node("generic_building").update_path

func _start_new_path(prev_coord, this_coord):
	var prev_pos = _main_scene.cell_coord_to_pos(prev_coord) + _main_scene.quadrant_size() * 0.5

	var this_pos = _main_scene.cell_coord_to_pos(this_coord) + _main_scene.quadrant_size() * 0.5

	var new_path: Path2D = _main_scene.create_node(new_path_path, _paths)
	new_path.curve.add_point(prev_pos)
	new_path.curve.add_point(this_pos)

	_path = new_path

